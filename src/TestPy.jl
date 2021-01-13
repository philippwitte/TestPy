
module TestMod
    using PyCall
    export hello_world

    # Add to path
    sys = pyimport("sys")
    sys.path = push!(sys.path, "/home/pwitte/TestPy")

    # Load python module
    pymode = pyimport("pymodule")

    # Functions
    hello_world(name) = pymode.hello_world(name)
end

