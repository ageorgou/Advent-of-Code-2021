module day02

using ..ReTest

TEST_STRING = "forward 5
down 5
forward 8
up 3
down 8
forward 2"


function move(initial, instruction::String)
    horizontal, depth = initial
    parts = split(instruction)
    if length(parts) != 2
        error("Malformed instruction $instruction")
    end
    command, number = parts[1], parse(Int, parts[2])
    if command == "forward"
        (horizontal + number, depth)
    elseif command == "down"
        (horizontal, depth + number)
    elseif command == "up"
        (horizontal, depth - number)
    else
        error("Unrecognised command $command")
    end
end

function solve(io::IO)
    position = (0, 0)
    for line in eachline(io)
        position = move(position, line)
    end
    position, prod(position)
end

@testset "day02" begin
    @test solve(IOBuffer(TEST_STRING)) == ((15, 10), 150)
end

end #module