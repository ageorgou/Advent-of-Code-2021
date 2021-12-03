module day03

using ..ReTest

function getDigits(line::String)
    [parse(Int, c) for c in line]
end

function getUpdate(line::String)
    update = getDigits(line)
    update[update .== 0] .= -1
    return update
end

function solve(io::IO)
    # Count the ones in each position across the lines
    diffs = sum(getUpdate(line) for line in eachline(io))
    # Assume no ties!
    mostCommon = reverse(diffs .> 0)  # reverse for simpler computation
    epsilon = evalpoly(2, mostCommon)
    gamma = evalpoly(2, .~mostCommon)
    (epsilon, gamma, epsilon * gamma)
end

const TEST_STRING = """
00100
11110
10110
10111
10101
01111
00111
11100
10000
11001
00010
01010"""

@testset "day03" begin
    @test solve(IOBuffer(TEST_STRING)) == (22, 9, 198)
end

end