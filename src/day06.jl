module day06

using ..ReTest

function nextDay(n::Int)
    n > 0 ? (n - 1) : 6
end

function updateAges(ages::Vector{Int})
    # NB: iterates over the list twice
    nReadyToSpawn = sum(ages .== 0)
    vcat([nextDay(age) for age in ages], 8 * ones(Int, nReadyToSpawn))
end

function simulate(init::Vector{Int}, nDays::Int)
    ages = init
    for _ in range(1, length=nDays)
        ages = updateAges(ages)
    end
    ages
end

function solve(io::IO; nDays=80)
    init = [parse(Int, s) for s in split(readline(io), ',')]
    length(simulate(init, nDays))
end

const TEST_INPUT = "3, 4, 3, 1, 2"

@testset "final" begin
    @test solve(IOBuffer(TEST_INPUT), nDays=18) == 26
    @test solve(IOBuffer(TEST_INPUT), nDays=80) == 5934
end

end