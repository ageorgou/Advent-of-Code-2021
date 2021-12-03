module day03

using ..ReTest

function solve(io::IO)
    # Get the number of digits from the string for future reference,
    # as it may not be clear from the numbers themselves
    firstLine = readline(io)
    nDigits = length(firstLine)
    first = parse(Int, firstLine, base=2)
    nLines = 1
    ones = digits(first, base=2, pad=nDigits)
    # Count the ones in each position across the lines
    for line in eachline(io)
        ones += digits(parse(Int, line, base=2), base=2, pad=nDigits)
        nLines += 1
    end
    # Assume no ties!
    mostCommon = ones .> (nLines / 2)
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