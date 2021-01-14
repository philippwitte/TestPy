
# Load local Redwood package
batchdir = ENV["AZ_BATCH_TASK_WORKING_DIR"]
#push!(LOAD_PATH, batchdir)

using Redwood, Serialization

# Load packages first
try
    iostream = open("packages.dat", "r")
    package_expr = deserialize(iostream)
    close(iostream)
    eval(package_expr)
catch
    nothing
end

# Load AST
filename = ENV["FILENAME"]
iostream = open(join([batchdir, "/", filename]), "r")
ast = deserialize(iostream)
close(iostream)

# Execute
for expr in ast.args
    eval(expr)
end
