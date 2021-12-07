module day07

using ..ReTest

function distances(locations)
    locations .- locations'
end

function optimalCost(locations)
    # This assumes that the optimal alignment will coincide with
    # the initial location of at least one crab... which I'm not convinced of.
    # We're also creating too big an array, since we don't take into account
    # that multiple crabs can be in the same position initially.
    dists = abs.(distances(locations))
    minimum(sum(dists, dims=1))
end

function compoundCost(distance)::Int
    (distance * (distance + 1)) / 2
end

function compoundCost(locations, target)::Int
    dists = abs.(locations .- target)
    sum(compoundCost.(dists))
end

function optimalCompoundCost(locations)
    # Not true! Optimal solution may not match any initial position
    # dists = abs.(distances(locations))
    # minimum(sum(compoundCost.(dists), dims=1))
    minimum(
        compoundCost(locations, x)
        for x in minimum(locations):maximum(locations)
    )
end

function solve(io::IO, compound=false)
    locs = [parse(Int, s) for s in split(readline(io), ',')]
    compound ? optimalCompoundCost(locs) : optimalCost(locs)
end


TEST_INPUT = [16,1,2,0,4,2,7,1,2,14]

@testset "day07" begin
    @test optimalCost(TEST_INPUT) == 37
    @test compoundCost(3) == 6
    @test compoundCost(TEST_INPUT, 5) == 168
    @test compoundCost(TEST_INPUT, 2) == 206
    @test optimalCompoundCost(TEST_INPUT) == 168
end

end