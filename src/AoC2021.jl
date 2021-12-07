module AoC2021

using ReTest

for day in range(1, length=7)
    include("day$(string(day, pad=2)).jl")
end

end # module
