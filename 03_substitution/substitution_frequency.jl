using DataStructures

message = 
"swlkwksiojjwrwaiukcdwvspundswevszdcfwujdvfdonaunocpwrvkdqvucfwlkne" *
"cqvucfwhovfddundulokfrfkdvnrokddonswdqvufuncwrfwjkwfdhovfdsweufaon" *
"wcukclwnvulwasvkjukdurfwdawdqvufuncwhovfdswdrufwncdpveufaonsvkuluk" *
"wncpkcqvwswlkwksiojjwwcukczknuswjwncwcpwzknkcklwjwncdusuoawqvkwdcs" *
"urkfwzofjwrovfpkfwrudpwaiunawwcdwsonswvfdofpfwdsweufaonwcukcrufckd" *
"vfvnuvcfwmucwuvswqvwsulukcrfkdcfokdefodrokddondsurfwjkwfwdwjuknwaw" *
"suswfwnpukccfkdcwsweufaonpwlokfswlkwksiojjwfwlwnkfaiuqvwdokfswauno" *
"clkpwwccovhovfdksswfwhokenukcrovfsukpwfurofcwfswdskenwdwnfovswdsue" *
"uzzwswiufronwcsulokswzwfswwuvcovfpvjucvnwlokswfurkwawwulwapwdduadp" *
"wzufknwqvkrwnpukcukndkaojjwswpfurwuvpvnwrwfjunwncwpwzukcwswlkwksio" *
"jjwwcukcjukefwwciulwulwapwrfozonpwdfkpwdpundsuffkwfwpvaovdvfdwdhov" *
"wdswdcuaiwdmfvnwdpvnaunawfpwsurwuvmwnknuauvdwpwsufwzswbkonpvdoswks" *
"dvfsujwfpwdcforkqvwdswdcuaiwdsvkcojmukwncpwaiuqvwaocwpvlkduewwcdwd" *
"jukndeufpukwncswdakaucfkawdrfozonpwjwncrskddwwdpwdrokddondiuswdsov" *
"fpwjwncdvfsuaofpwjukduvavnwpwawdakaucfkawdrovfwcfwfwawncwwsswdwcuk" *
"wncuvddklkwksswdqvwswfodkonpundswpwdwfcdundrokddon"
ALPH_LOWER = "abcdefghijklmnopqrstuvwxyz"
ALPH_UPPER = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
FREQ_FRA = [0.0815, 0.0097, 0.0315, 0.0373, 0.1739, 0.0112, 0.0097, 0.0085, 0.0731, 0.0045, 0.0002, 0.0569, 0.0287, 0.0712, 0.0528, 0.0280, 0.0121, 0.0664, 0.0814, 0.0722, 0.0638, 0.0164, 0.0003, 0.0041, 0.0028, 0.0015]

"get the frequence of each ngram"
function ngrams_frequence(message, n)
    ngrams = [message[i:i + n - 1] for i in 1:length(message) + 1 - n]
    occurences = Dict(counter(ngrams))
    return Dict(k[1] => occurences[k] / length(message) for k in keys(occurences))
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

"get the frequency of each letter in the ciphered message"
function get_freq_message()
    unigrams = ngrams_frequence(message, 1)
    freq_message = []
    for letter_i in 1:length(ALPH_LOWER)
        current_letter = ALPH_LOWER[letter_i]
        current_letter in keys(unigrams) ? append!(freq_message, unigrams[current_letter]) : append!(freq_message, 0)
    end
    return freq_message
end    

"""
suggest replacements of letter based
a comparison between frequency in the
french language and frequency in the
ciphered message
"""
function make_freq_replacements(freq_message)
     replacements = Dict()
     for index in 1:10
        index_fra = sortperm(FREQ_FRA, rev=true)[index]
        index_message = sortperm(freq_message, rev=true)[index]
        replacements[ALPH_LOWER[index_message]] = ALPH_UPPER[index_fra]
     end
    return replacements
end

freq_message = get_freq_message()
freq_replacements = make_freq_replacements(freq_message)
display_replacements(message, freq_replacements) 

subseq_replacements = Dict(freq_replacements)
freq_replacements

# correction 1
subseq_replacements['s'] = 'L'
subseq_replacements['l'] = 'V'
subseq_replacements['o'] = 'O'
subseq_replacements['i'] = 'H'
subseq_replacements['j'] = 'M'
display_replacements(message, subseq_replacements) 

# correction 2
subseq_replacements['r'] = 'P'
subseq_replacements['a'] = 'C'
subseq_replacements['c'] = 'T'
subseq_replacements['v'] = 'U'
display_replacements(message, subseq_replacements) 

# correction 3
subseq_replacements['p'] = 'D'
subseq_replacements['n'] = 'N'
subseq_replacements['e'] = 'G'
subseq_replacements['z'] = 'F'
subseq_replacements['f'] = 'R'
subseq_replacements['q'] = 'Q'
subseq_replacements['h'] = 'J'
subseq_replacements['m'] = 'B'
subseq_replacements['b'] = 'X'
display_replacements(message, subseq_replacements) 


