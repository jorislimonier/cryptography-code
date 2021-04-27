using DataStructures

message = "hwowlesratowzwpallwmheiwslwlbwowlzwpafswl"
ALPH_LOWER = "abcdefghijklmnopqrstuvwxyz"

"""
number of ngrams
for a given value of n
"""
function ngrams_occurences(message, n)
    ngrams = [message[i:i + n - 1] for i in 1:length(message) + 1 - n]
    return Dict(counter(ngrams))
end

"show the effect of replacing letters"
function display_replacements(message, replacements)
    for (old_letter, new_letter) in replacements
        message = replace(message, old_letter => new_letter)
    end
    for lower_letter in ALPH_LOWER
        message = replace(message, lower_letter => ".")
    end
    return message
end

unigrams = ngrams_occurences(message, 1)
trigrams = ngrams_occurences(message, 3)
replacements1 = Dict(
    "t" => "Q",
    "o" => "U",
    "w" => "E",
)
replacements2 = Dict(
    "e" => "Q",
    "i" => "U",
    "w" => "E",
)
replacements3 = Dict(
    "s" => "Q",
    "l" => "U",
    "w" => "E",
)
replacements4 = Dict(
    "l" => "Q",
    "b" => "U",
    "w" => "E",
)
replacements5 = Dict(
    "l" => "Q",
    "z" => "U",
    "w" => "E",
)
replacements6 = Dict(
    "f" => "Q",
    "s" => "U",
    "w" => "E",
)

display_replacements(message, replacements1)
display_replacements(message, replacements2) 
display_replacements(message, replacements3)
display_replacements(message, replacements4)
display_replacements(message, replacements5)
display_replacements(message, replacements6) 

replacements6["l"] = "S"
replacements6["b"] = "F"
replacements6["p"] = "P"
replacements6["a"] = "A"
replacements6["z"] = "D"
replacements6["o"] = "T"
replacements6["h"] = "J"
replacements6["r"] = "H"
replacements6["i"] = "Y"
replacements6["e"] = "O"
replacements6["t"] = "I"
replacements6["m"] = "R"

display_replacements(message, replacements6) 