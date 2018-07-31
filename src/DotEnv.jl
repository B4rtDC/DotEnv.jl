module DotEnv

const DOUBLE_QUOTE = '"'

function parse( src )
    res = Dict{String,String}()
    for line in split(String(src), '\n')
        m = match(r"^\s*([\w.-]+)\s*=\s*(.*)?\s*$", line)
        if m != nothing
            key = m.captures[1]
            value = m.captures[2]

            len = value != "" ? length(value) : 0
            if (len > 0 && value[1] === DOUBLE_QUOTE && value[end] === DOUBLE_QUOTE)
                value = replace(value, r"\\n"m, "\n")
            end

            value = replace(value, r"(^['\u0022]|['\u0022]$)", "")

            value = strip(value)

            push!(res, Pair(key, value) )
        end
    end
    res
end

function config( path=".env" )
    if (isfile(path))
            parsed = parse(String(read(path)))

            for (k, v) in parsed
                if( !haskey( ENV, k ) )
                    ENV[k] = v
                end
            end

            return parsed
    else
        warn(".env file not found")
        return nothing
    end
end

load(opts...) = config(opts...)

end