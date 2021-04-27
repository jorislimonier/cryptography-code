include("./vigenere_decipher.jl")
using StatsBase
using LinearAlgebra

function DEF_GLOBAL_VARIABLES()
    """define all global variables"""
    global ALPH = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    global THREE = "WDGARAUDHTIZPWPGLIVZDAODPPOWHNRUDEW" # texte en anglais
    global FOUR =
    "VGNFBZZNKKTJLUQXXGCCVGNFBZKMTTBJKRMXTHMN" * "ERMXVGKMTYAJEKASNGOJLKBKTOBGKOTQXXTJLUTJ" * "BRKFYGQYKOZJEKATBYMFNDMYWGVXXXTJLKKZKKCN" * "EYKFKGRTNZMIXYKTNRMZKYIZQIWZEKCWLJMQTXKJ" * "GIQJEYQDTJTFIRCNXJISLZIABKANEKATBXBJYGQY" * "IKCWEGUZLOYZXKAYEGXTNXKFVUUUTMVNXIZJHRM"
    global FREQ_ENG = [0.082, 0.015, 0.028, 0.043, 0.127, 0.022, 0.020, 0.061, 0.070, 0.002, 0.008, 0.040, 0.024, 0.067, 0.075, 0.019, 0.001, 0.060, 0.060, 0.091, 0.028, 0.010, 0.023, 0.001, 0.020, 0.001]
    global FREQ_FRA = [0.0815, 0.0097, 0.0315, 0.0373, 0.1739, 0.0112, 0.0097, 0.0085, 0.0731, 0.0045, 0.0002, 0.0569, 0.0287, 0.0712, 0.0528, 0.0280, 0.0121, 0.0664, 0.0814, 0.0722, 0.0638, 0.0164, 0.0003, 0.0041, 0.0028, 0.0015]
end

function sort_argmax_decr(arr)
    """sort arguments of decreasing order values"""
    decr_argmax = []
    for i in 1:length(arr)
        curr_argmax = argmax(arr)
        append!(decr_argmax, curr_argmax)
        arr = vcat(arr[1:curr_argmax - 1], -Inf16, arr[curr_argmax + 1:length(arr)])
    end
    return decr_argmax
end

function generate_subsequence(index_searched, cipher_text, key_length)
    """generates a subsequence with all letters in position
    congruent to index_searched modulo key_length"""
    subseq = []
    for i in 0:length(cipher_text) - 1
        if (i % key_length) + 1 == index_searched
            append!(subseq, cipher_text[i + 1])
        end
    end
    return subseq
end

function compute_freq(message)
    """returns the frequency of each letter in message"""
    freq = countmap(letter for letter in message)
    for letter in ALPH
        if !(letter in keys(freq)) 
            freq[letter] = 0
        end
    end
    return freq
end

function generate_subseq_freq(index_searched, cipher_text, key_length)
    """creates an array of frequences with respect to alphabetically sorted letters"""
    subseq = generate_subsequence(index_searched, cipher_text, key_length)
    subseq_freq = compute_freq(subseq) # dict of frequencies
    subseq_freq = [subseq_freq[letter] for letter in ALPH] # alphabetically order array of frequencies
    subseq_freq /= sum(subseq_freq) # F'
    return subseq_freq
end

function find_likely_keys(n_most_likely, lang, cipher_text, key_length)
    """find most likely keys using frequncy analysis
    returns n_most_likely possibilities for each slot of the key length
    possibilities grow in (n_most_likely ^ key_length)"""
    
    FREQ_LANG = lang == "fra" ? FREQ_FRA : FREQ_ENG
    likely_keys = Dict(i => [] for i in 1:key_length)
    for index_searched in 1:key_length
        subseq_freq = generate_subseq_freq(index_searched, cipher_text, key_length)
        dot_prod_shift = [dot(subseq_freq, circshift(FREQ_LANG, shift)) for shift in 0:25] # F_j, 0 \leq j \leq 25
        append!(likely_keys[index_searched], [ALPH[ord] for ord in sort_argmax_decr(dot_prod_shift)[1:n_most_likely]])
    end
    likely_keys = [likely_keys[i] for i in 1:key_length]
    likely_keys = collect(Iterators.product(values(likely_keys)...))
    likely_keys = [string(likely_key...) for likely_key in likely_keys]
    return likely_keys
end

function display_likely_keys(n_most_likely, lang, message, key_length)
    """print all deciphers from the likely_keys"""
    likely_keys = find_likely_keys(n_most_likely, lang, message, key_length)
    for likely_key in likely_keys
        println("$likely_key: ", vig_decipher.shift_message(message, likely_key, true))
    end
end

DEF_GLOBAL_VARIABLES()

# EXERCISE 3
display_likely_keys(1, "eng", THREE, 3)
display_likely_keys(2, "eng", THREE, 3)

# EXERCISE 4
display_likely_keys(1, "fra", FOUR, 4)

