// Copyright (c) 2021 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/grpc;
import ballerina/io;
import ballerina/protobuf.types.wrappers;

// Server endpoint configuration
listener grpc:Listener ep8 = new (9098, {
    host:"localhost"
});

@grpc:ServiceDescriptor {
    descriptor: ROOT_DESCRIPTOR_08_UNARY_SERVICE_WITH_HEADERS,
    descMap: getDescriptorMap08UnaryServiceWithHeaders()
}
service "HelloWorld101" on ep8 {
    isolated remote function hello(HelloWorld101StringCaller caller, ContextString request) returns error? {
        io:println("name: " + request.content);
        string message = "Hello " + request.content;
        map<string|string[]> responseHeaders = {};

        if !request.headers.hasKey("x-id") {
            grpc:Error? err = caller->sendError(error grpc:AbortedError("x-id header is missing"));
        } else {
            string headerValue = check grpc:getHeader(request.headers, "x-id");
            io:println("Request Header: " +  headerValue);
            responseHeaders["x-id"] = ["1234567890", "2233445677"];
            io:print("Response headers: ");
            io:println(grpc:getHeaders(request.headers, "x-id"));
        }
        wrappers:ContextString responseMessage = {content: message, headers: responseHeaders};
        grpc:Error? err = caller->sendContextString(responseMessage);
        if err is grpc:Error {
            io:println("Error from Connector: " + err.message());
        } else {
            io:println("Server send response : " + message);
        }
    }
}