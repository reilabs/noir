comptime fn derive_default(typ: TypeDefinition) -> Quoted {
    let generics = typ.generics();
    assert_eq(
        generics.len(),
        0,
        "derive_default: Deriving Default on generic types is currently unimplemented",
    );

    let type_name = typ.as_type();
    let fields = typ.fields_as_written();

    let fields = join(make_field_exprs(fields));

    quote {
        impl Default for $type_name {
            fn default() -> Self {
                Self { $fields }
            }
        }
    }
}

// Bar needs to be defined before Foo so that its impls are defined before
// Foo's are.
#[derive_default]
struct Bar {}

#[derive_default]
struct Foo {
    x: Field,
    y: Bar,
}

comptime fn make_field_exprs(fields: [(Quoted, Type, Quoted)]) -> [Quoted] {
    let mut result = &[];
    for my_field in fields {
        let name = my_field.0;
        result = result.push_back(quote { $name: Default::default(), });
    }
    result
}

comptime fn join(slice: [Quoted]) -> Quoted {
    let mut result = quote {};
    for elem in slice {
        result = quote { $result $elem };
    }
    result
}

fn main() {
    let _foo: Foo = Default::default();
}
