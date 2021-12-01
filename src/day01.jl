module day01

using ..ReTest

function solve(io::IO)
    v = [parse(Int, line) for line in eachline(io)]
    sum(next > prev for (prev, next) in zip(v, v[2:end]))
end

function solvePart2(io::IO)
    v = [parse(Int, line) for line in eachline(io)]
    sums = [sum(z) for z in zip(v, v[2:end], v[3:end])]
    sum(next > prev for (prev, next) in zip(sums, sums[2:end]))
end

const TEST_STRING = """199
200
208
210
200
207
240
269
260
263"""

@testset "day01" begin
    @test solve(IOBuffer(TEST_STRING)) == 7
    @test solvePart2(IOBuffer(TEST_STRING)) == 5
end

end # module