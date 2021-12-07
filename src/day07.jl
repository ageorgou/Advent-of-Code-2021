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

function solve(io::IO)
    locs = [parse(Int, s) for s in split(readline(io), ',')]
    optimalCost(locs)
end

TEST_INPUT = [16,1,2,0,4,2,7,1,2,14]

@testset "day07" begin
    @test optimalCost(TEST_INPUT) == 37
end

end