use acvm::{
    FieldElement,
    acir::circuit::{ExpressionWidth, Program},
};
use iter_extended::vecmap;
use noirc_driver::{CompiledContract, CompiledProgram};
use noirc_errors::debug_info::DebugInfo;

/// Apply ACVM optimizations on the circuit.
pub fn transform_program(
    mut compiled_program: CompiledProgram,
    expression_width: ExpressionWidth,
) -> CompiledProgram {
    compiled_program.program = transform_program_internal(
        compiled_program.program,
        &mut compiled_program.debug,
        expression_width,
    );
    compiled_program
}

/// Apply the optimizing transformation on each function in the contract.
pub fn transform_contract(
    contract: CompiledContract,
    expression_width: ExpressionWidth,
) -> CompiledContract {
    let functions = vecmap(contract.functions, |mut func| {
        func.bytecode =
            transform_program_internal(func.bytecode, &mut func.debug, expression_width);
        func
    });

    CompiledContract { functions, ..contract }
}

fn transform_program_internal(
    mut program: Program<FieldElement>,
    debug: &mut [DebugInfo],
    expression_width: ExpressionWidth,
) -> Program<FieldElement> {
    let functions = std::mem::take(&mut program.functions);

    let optimized_functions = functions
        .into_iter()
        .enumerate()
        .map(|(i, function)| {
            let (optimized_circuit, location_map) =
                acvm::compiler::compile(function, expression_width);
            debug[i].update_acir(location_map);
            optimized_circuit
        })
        .collect::<Vec<_>>();

    program.functions = optimized_functions;
    program
}
