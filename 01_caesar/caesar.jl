ONE_A = "la rencontre a lieu ce matin" 
ONE_B = "HJXYQJUFWYDIZAJSIWJIN"

function shift_letter(letter, key)
    """shifts letter from key positions
    -> give a positive key to cipher
    -> give a negative key to decipher"""
    letter = uppercase(letter) # convert letter to uppercase
    old_letter_int = Int(only(letter)) 
    if old_letter_int + key < 65 # order of letter 'a'
        new_letter_int = old_letter_int + key + 26
    elseif old_letter_int + key > 95 # order of letter 'z'
        new_letter_int = old_letter_int + key - 26
    else
        new_letter_int = old_letter_int + key
    end
    return string(Char(new_letter_int))
end

function shift_message(message, key)
    """shifts message from key positions"""
    message = replace(message, " "=>"") # remove blanks spaces
    deciphered_message = ""
    for letter in message
        deciphered_message *= shift_letter(letter, key)
    end
    return deciphered_message

end

shift_message(ONE_A, 6) # returns "rgxktiutzxkgrokaiksgzot"

for shift in -1:-1:-25  # returns decyphered messages
                        # given keys ranging from 1 to 25
    println(shift, " ", shift_message(ONE_B, shift))
end