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

function mostCommon(digits)
    oneCount = sum(digits)
    zeroCount = length(digits) - oneCount
    (oneCount >= zeroCount) ? 1 : 0
end

function parseAllDigits(io::IO)
    vectors = [
        BitVector(getDigits(line))'  # we want one matrix row per file line
        for line in eachline(io)
    ]
    vcat(vectors...)
end

function findMatching(digits::BitMatrix, chooseMost::Bool)
    candidates = digits
    considered = 0
    while size(candidates, 1) > 1
        considered += 1
        target = mostCommon(candidates[:, considered])
        chooseMost || (target = 1- target)
        matching = candidates[:, considered] .== target
        candidates = candidates[matching, :]
    end
    candidates[1, :]
end

function asDecimal(digits::BitVector)
    evalpoly(2, reverse(digits))
end

function solve(io::IO)
    # Count the ones in each position across the lines
    diffs = sum(getUpdate(line) for line in eachline(io))
    # Assume no ties!
    mostCommon = diffs .> 0
    epsilon = asDecimal(mostCommon)
    gamma = asDecimal(.~mostCommon)
    (epsilon, gamma, epsilon * gamma)
end

function solvePart2(io::IO)
    allDigits = parseAllDigits(io)
    O2 = asDecimal(findMatching(allDigits, true))
    CO2 = asDecimal(findMatching(allDigits, false))
    (O2, CO2, O2 * CO2)
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

const TEST_STRING_SHORT = """
00100
11110
"""

const TEST_DIGITS = parseAllDigits(IOBuffer(TEST_STRING))

@testset "day03_support" begin
    @test asDecimal(BitVector([0, 1, 0, 0])) == 4
end

@testset "day03" begin
    @test solve(IOBuffer(TEST_STRING)) == (22, 9, 198)
end

@testset "day03_part2" begin
    @test mostCommon([0 1 0]) == 0
    @test mostCommon([1 0 1]) == 1
    @test mostCommon([1 1 0 0 0]) == 0
    @test mostCommon([0]) == 0
    @test mostCommon([1]) == 1
    @test mostCommon([1, 0]) == 1
    @test parseAllDigits(IOBuffer(TEST_STRING_SHORT)) == BitMatrix([
        0 0 1 0 0
        1 1 1 1 0
    ])
    @test findMatching(TEST_DIGITS, true) == BitVector([1, 0, 1, 1, 1])
    @test findMatching(TEST_DIGITS, false) == BitVector([0, 1, 0, 1, 0])
    @test solvePart2(IOBuffer(TEST_STRING)) == (23, 10, 230)
end


end