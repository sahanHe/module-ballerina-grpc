import ballerina/grpc;

listener grpc:Listener ep = new (9090);

@grpc:ServiceDescriptor {descriptor: HELLOWORLDFLOAT_DESC}
service "helloWorld" on ep {

    remote function hello(stream<float, grpc:Error?> clientStream) returns float|error {
    }
}

