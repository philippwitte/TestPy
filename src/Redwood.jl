# Light version of Redwood for batch runtime
# Philipp A. Witte
# November 2020
# 

# "Redwood light" for batch runtime
module Redwood
    using Serialization
    export BlobRef, BatchFuture, BlobFuture, fetch!
    import Base.fetch

    mutable struct BlobRef
        name::Union{String, Tuple}
    end

    mutable struct BatchFuture
        container::String
        blob
    end

    function fetch(arg::BatchFuture)
        iostream = open(arg.blob.name, "r")
        data = deserialize(iostream)
        close(iostream)
        return data
    end

    function fetch!(arg::BatchFuture)
        iostream = open(arg.blob.name, "r")
        arg.blob = deserialize(iostream)
        close(iostream)
        return arg.blob
    end

    mutable struct BlobFuture
        container::String
        blob
    end

    function fetch(arg::BlobFuture)

        num_files = length(arg.blob.name)
        out_files = []
        for blob in arg.blob.name

            # Fetch blob and add to collection
            iostream = open(blob, "r")
            push!(out_files, deserialize(iostream))
            close(iostream)
        end
        
        if num_files > 1
            data = tuple(out_files...)
        else
            data = out_files[1]
        end
        return data
    end

    function fetch!(arg::BlobFuture)

        num_files = length(arg.blob.name)
        out_files = []
        for blob in arg.blob.name

            # Fetch blob and add to collection
            iostream = open(blob, "r")
            push!(out_files, deserialize(iostream))
            close(iostream)
        end
        
        if num_files > 1
            arg.blob = tuple(out_files...)
        else
            arg.blob = out_files[1]
        end
        return arg.blob
    end
end

