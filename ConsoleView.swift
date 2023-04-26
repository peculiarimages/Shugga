//
//  ConsoleView.swift
//  Shugga
//
//  Created by Rodi on 3/2/23.
//


import SwiftUI
import os.log

struct ConsoleView: View {
    @State private var consoleOutput: String = ""

    var body: some View {
        ScrollView {
            VStack {
                Text(consoleOutput)
                    .font(.system(size: 10))

                    .padding()
                    .frame(maxHeight: 250)
                    .lineLimit(nil)
                    .onAppear {
                        let consolePipe = RedirectedConsolePipe()
                        consolePipe.redirectToClosure { log in
                            consoleOutput += log + "\n"
                        }
                    }
            }
        }
    }
}


class RedirectedConsolePipe {
    private let pipe = Pipe()
    private var pipeReadHandle: FileHandle!
    private var consoleWriteHandle: FileHandle!

    init() {
        pipeReadHandle = pipe.fileHandleForReading
        consoleWriteHandle = FileHandle.standardOutput
        dup2(consoleWriteHandle.fileDescriptor, STDERR_FILENO)
        dup2(pipe.fileHandleForWriting.fileDescriptor, STDOUT_FILENO)
    }

    func redirectToClosure(closure: @escaping (String) -> Void) {
        DispatchQueue.global(qos: .background).async {
            while let line = self.pipeReadHandle.readLine() {
                closure(line)
            }
        }
    }
}

extension FileHandle {
    func readLine() -> String? {
        let data = self.availableData
        guard data.count > 0 else {
            return nil
        }
        return String(data: data, encoding: .utf8)?.trimmingCharacters(in: .newlines)
    }
}


struct ConsoleView_Previews: PreviewProvider {
    static var previews: some View {
        ConsoleView()
    }
}
