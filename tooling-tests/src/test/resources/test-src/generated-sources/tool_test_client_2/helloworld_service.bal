import ballerina/grpc;

listener grpc:Listener ep = new (9090);

@grpc:ServiceDescriptor {descriptor: HELLOWORLDINT_DESC}
service "helloWorld" on ep {

    remote function hello(stream<int, grpc:Error?> clientStream) returns int|error {
    }
}

