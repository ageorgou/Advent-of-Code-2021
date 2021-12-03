module day03

using ..ReTest

function getUpdate(line::String, nDigits::Int)
    update = digits(parse(Int, line, base=2), base=2, pad=nDigits)
    update[update .== 0] .= -1
    return update
end

function solve(io::IO)
    # Get the number of digits from the string for future reference,
    # as it may not be clear from the numbers themselves
    firstLine = readline(io)
    nDigits = length(firstLine)
    diffs = getUpdate(firstLine, nDigits)
    # Count the ones in each position across the lines
    for line in eachline(io)
        diffs += getUpdate(line, nDigits)
    end
    # Assume no ties!
    mostCommon = diffs .> 0
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