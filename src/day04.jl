module day04

using ..ReTest

struct BingoTable
    numbers::Matrix{Int}
    matching::BitMatrix
    BingoTable(t) = size(t) == (5, 5) ? new(t, falses(5, 5)) : error("Bad dimensions")
end

function readInput(io::IO)
    numbers = [parse(Int, n) for n in split(readline(io), ',')]
    tables = Vector{BingoTable}()
    while !eof(io)
        readline(io) # assume empty line between each sections
        table = zeros(Int, 5, 5)
        for i = 1:5
            table[i,:] = [parse(Int, n) for n in split(readline(io))]
        end
        push!(tables, BingoTable(table))
    end
    return (numbers, tables)
end

function checkMatches(collection::Vector{BingoTable}, n)
    winners = Vector{Int}()
    for (i, table) in enumerate(collection)
        if checkMatches(table, n)
            push!(winners, i)
        end
    end
    return winners
end

function checkMatches(table::BingoTable, n)
    matches = findall(table.numbers .== n)
    if !isempty(matches)
        table.matching[matches] .= true
        # check if won
        return isWinning(table.matching)
    end
    return false
end

function isWinning(matches::BitMatrix)
    any(all(matches, dims=1)) || any(all(matches, dims=2))
end

function score(table::BingoTable, winningNumber::Int)
    sum(table.numbers[.! table.matching]) * winningNumber
end

function solve(io::IO)
    numbers, tables = readInput(io)
    for n in numbers
        winners = checkMatches(tables, n)
        if !isempty(winners)
            # assuming many can win concurrently
            return [score(tables[i], n) for i in winners]
        end
    end
    error("Noone won")
end

const TEST_INPUT = """
7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1

22 13 17 11  0
 8  2 23  4 24
21  9 14 16  7
 6 10  3 18  5
 1 12 20 15 19

 3 15  0  2 22
 9 18 13 17  5
19  8  7 25 23
20 11 10 24  4
14 21 16 12  6

14 21 17 24  4
10 16 15  9 19
18  8 23 26 20
22 11 13  6  5
 2  0 12  3  7
"""

@testset "input" begin
    @test length(readInput(IOBuffer(TEST_INPUT))[1]) == 27
    @test length(readInput(IOBuffer(TEST_INPUT))[2]) == 3
    @test solve(IOBuffer(TEST_INPUT)) == [4512]
end

end