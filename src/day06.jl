module day06

using ..ReTest

function nextDay(n::Int)
    n > 0 ? (n - 1) : 6
end

function updateAges(counts::Dict{Int, Int})
    newCounts = Dict{Int, Int}(n => 0 for n in range(0, 8, step=1))
    for (k, v) in counts
        newCounts[nextDay(k)] += v
    end
    newCounts[8] = counts[0]
    return newCounts
end

function simulate(init::Dict{Int, Int}, nDays::Int)
    counts = init
    for _ in range(1, length=nDays)
        counts = updateAges(counts)
    end
    counts
end

function solve(io::IO; nDays=80)
    ages = [parse(Int, s) for s in split(readline(io), ',')]
    init = Dict{Int, Int}(n => 0 for n in range(0, 8, step=1))
    for age in ages
        init[age] += 1
    end
    sum(values(simulate(init, nDays)))
end

const TEST_INPUT = "3, 4, 3, 1, 2"

@testset "final" begin
    @test solve(IOBuffer(TEST_INPUT), nDays=18) == 26
    @test solve(IOBuffer(TEST_INPUT), nDays=80) == 5934
    @test solve(IOBuffer(TEST_INPUT), nDays=256) == 26984457539
end

end