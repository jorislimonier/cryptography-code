cycles = [[1, 3], [2, 4, 5]]
message_ex1 = "melsegeseadesctptrey"

"find element of cycles which should replace original_elem"
function substitute_of(original_elem, cycles)
    for cycle in cycles
        for cycle_i in 1:length(cycle)
            if cycle[cycle_i] == original_elem
                if cycle_i == length(cycle)
                    return first(cycle)
                else
                    return cycle[cycle_i + 1]
                end
            end
        end
    end
end

"substitutes the chunk with key cycles"
function substituted_chunk(chunk, cycles)
    new_chunk = ""
    for letter_i in 1:length(chunk)
        new_chunk *= chunk[substitute_of(letter_i, cycles)]
    end
    return new_chunk
end

"""
substitutes the message chunk by chunk
every chunk has length of the maximum of cycles
"""
function substitute_message(message, cycles, decipher)
    # if deciphering, turn the cycles around
    if decipher
        cycles = Tuple(cycle[end:-1:1] for cycle in cycles)
    end
    cycle_length = findmax(vcat(cycles...))[1]
    chunks = [message[i:i + cycle_length - 1] for i in 1:cycle_length:length(message)]
    substituted_message = ""
    for chunk in chunks
        substituted_message *= substituted_chunk(chunk, cycles)
    end
    return substituted_message
end

substitute_message(message_ex1, cycles, true) # returns "lemessageestdecrypte"