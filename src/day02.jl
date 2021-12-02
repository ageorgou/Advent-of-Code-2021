module day02

using ..ReTest

TEST_STRING = "forward 5
down 5
forward 8
up 3
down 8
forward 2"


function move(initial, instruction::String)
    parts = split(instruction)
    if length(parts) != 2
        error("Malformed instruction $instruction")
    end
    command, number = parts[1], parse(Int, parts[2])
    if command == "forward"
        displacement = (number, 0)
    elseif command == "down"
        displacement = (0, number)
    elseif command == "up"
        displacement = (0, -number)
    else
        error("Unrecognised command $command")
    end
    initial .+ displacement
end

function moveWithAim(initial, instruction::String)
    aim = initial[3]
    parts = split(instruction)
    if length(parts) != 2
        error("Malformed instruction $instruction")
    end
    command, number = parts[1], parse(Int, parts[2])
    if command == "forward"
        displacement = (number, number * aim, 0)
    elseif command == "down"
        displacement = (0, 0, number)
    elseif command == "up"
        displacement = (0, 0, -number)
    else
        error("Unrecognised command $command")
    end
    initial .+ displacement
end

function solve(io::IO)
    position = (0, 0)
    for line in eachline(io)
        position = move(position, line)
    end
    position, prod(position)
end

function solvePart2(io::IO)
    position = (0, 0, 0)
    for line in eachline(io)
        position = moveWithAim(position, line)
    end
    position[1:2], prod(position[1:2])
end

@testset "day02" begin
    @test solve(IOBuffer(TEST_STRING)) == ((15, 10), 150)
    @test solvePart2(IOBuffer(TEST_STRING)) == ((15, 60), 900)
end

end #module