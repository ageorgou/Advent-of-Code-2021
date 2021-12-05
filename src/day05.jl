module day05
    
using ..ReTest

struct Segment
    start::Tuple{Int, Int}
    stop::Tuple{Int, Int}
    Segment(start, stop) = new(start, stop)
    function Segment(spec::String)
        parts = split(spec, "->")
        start = tuple([parse(Int, strip(t)) for t in split(parts[1], ",")]...)
        stop = tuple([parse(Int, strip(t)) for t in split(parts[2], ",")]...)
        new(start, stop)
    end
end

function isHorizontal(segment::Segment)
    segment.start[2] ==  segment.stop[2]
end

function isVertical(segment::Segment)
    segment.start[1] ==  segment.stop[1]
end

function getAllPoints(s::Segment)
    if isHorizontal(s)
        limits = s.start[1], s.stop[1]
        return [(x, s.start[2]) for x in range(minimum(limits), stop=maximum(limits))]
    elseif isVertical(s)
        limits = s.start[2], s.stop[2]
        return [(s.start[1], y) for y in range(minimum(limits), stop=maximum(limits))]
    else
        # assume 45 degrees!
        stepX = sign(s.stop[1] - s.start[1])
        stepY = sign(s.stop[2] - s.start[2])
        return [
            (x, y)
            for (x, y) in zip(s.start[1]:stepX:s.stop[1], s.start[2]:stepY:s.stop[2])
        ]
    end
end

function solve(io::IO)
    visited = Set{Tuple{Int, Int}}()
    visitedTwice = Set{Tuple{Int, Int}}()
    # read input to get segments
    segments = [Segment(line) for line in eachline(io)]
    # for each segment, get points
    # add points to visited list
    # if already in visited, add to "at least 2" list
    for segment in segments
        # (isHorizontal(segment) || isVertical(segment)) || continue 
        newPoints = getAllPoints(segment)
        alreadySeen = findall(p -> p in visited, newPoints)
        union!(visitedTwice, newPoints[alreadySeen])
        union!(visited, newPoints)
    end
    length(visitedTwice)
end

const TEST_INPUT = """
0,9 -> 5,9
8,0 -> 0,8
9,4 -> 3,4
2,2 -> 2,1
7,0 -> 7,4
6,4 -> 2,0
0,9 -> 2,9
3,4 -> 1,4
0,0 -> 8,8
5,5 -> 8,2
"""

@testset "segment" begin
    @test Segment("5,5 -> 8,2").start == (5, 5)
    @test Segment("5,5 -> 8,2").stop == (8, 2)
    @test Segment(" 5 , 5 -> 8, 2").start == (5, 5)
    @test Segment(" 5 , 5 -> 8, 2").stop == (8, 2)
end

@testset "direction" begin
    @test isVertical(Segment("1,1 -> 1,3"))
    @test isHorizontal(Segment("9,7 -> 7, 7"))
    @test !isHorizontal(Segment((6, 4), (2, 0))) && !isVertical(Segment((6, 4), (2, 0)))
    @test getAllPoints(Segment("1,1 -> 3,3")) == [(1,1), (2,2), (3,3)]
    @test getAllPoints(Segment("9,7 -> 7,9")) == [(9,7), (8,8), (7,9)]
end

@testset "overall" begin
    @test solve(IOBuffer(TEST_INPUT)) == 5
end

end