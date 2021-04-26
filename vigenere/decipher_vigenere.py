# %%
import pandas as pd
import numpy as np
import plotly.graph_objects as go
from plotly.subplots import make_subplots
import plotly.express as px

# %% [markdown]
# # Using the index of coincidence

# %%
# encrypted text
ENCRYPTED_TEXT = np.array(list("""VVHQWVVRHMUSGJGTHKIHTSSEJCHLSFCBGVWCRLRYQTFSVGAHWKCUHWAUGLQHNSLRLJSHBLTSPISPRDXLJSVEEGHLQWKASSKUWEPWQTWVSPGOELKCQYFNSVWLJSNIQKGNRGYBWLWGOVIOKHKAZKQKXZGYHCECMEIUJOQKWFWVEFQHKIJRCLRLKBIENQFRJLJSDHGRHLSFQTWLAUQRHWDMWLGUSGIKKFLRYVCWVSPGPMLKASSJVOQXEGGVEYGGZMLJCXXLJSVPAIVWIKVRDRYGFRJLJSLVEGGVEYGGEIAPUUISFPBTGNWWMUCZRVTWGLRWUGUMNCZVILE"""))
ALPHABET = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

def create_df_freq(c):
    # returns the frequency of each letter in the encrypted message
    unique, count = np.unique(c, return_counts=True)
    counts = dict(zip(unique, count))
    for k in counts.keys():
        counts[k] = [counts[k]]
    return pd.DataFrame(data=counts)

create_df_freq(ENCRYPTED_TEXT)


# %%
def shift(c):
    # returns a dataframe where the i-th line is shifted by i
    df_shifted = pd.DataFrame(data=c).T
    for shift in range(1, len(c)):
        shifted_c = np.append(c[shift:], c[:shift])
        df_append = pd.DataFrame(data=shifted_c).T
        df_shifted = df_shifted.append(df_append, ignore_index=True)
    return df_shifted
df_shifted = shift(ENCRYPTED_TEXT)


# %%
df_shifted


# %%
def get_coinc(df_shifted):
    # returns a dataframe where the i-th column contains the index of coincidence after a shift of i
    df_coinc = pd.DataFrame()
    for i in range(1, len(df_shifted)):
        df_coinc[i] = [np.sum(df_shifted.iloc[0] == df_shifted.iloc[i])]
    return df_coinc
df_coinc = get_coinc(df_shifted)
df_coinc


# %%
fig = make_subplots(rows=1, cols=2, subplot_titles=["Number of shifts per index of coincidence", "Index of coincidence per shift"])

fig.add_trace(go.Histogram(x=df_coinc.iloc[0]), row=1, col=1)
fig.add_trace(go.Bar(x=df_coinc.columns,y=df_coinc.iloc[0]), row=1, col=2)

fig.update_layout(height=400, width=1200)


# %%
# this cell can definitely be optimized

# gets the indices of the shifts with maximum coincidence
def append_factors(n, factors):
    # get all factors of n
    for d in range(2, int(np.ceil(np.sqrt(n)))):
        if not n % d:
            factors = np.append(factors, [d, n/d])
    return factors

def get_factors(a, thresh):
    # gets the factors of the(thresh*100)% largest indices of coincidence
    factors = []
    data_thresh = int(thresh * df_coinc_desc.shape[1]) # the proportion of the factors we take
    for arg in a[:data_thresh]:
        factors = append_factors(arg, factors)
    return factors

df_coinc_desc = df_coinc.sort_values(by=0, ascending=False, axis=1).copy()
coinc_args_desc = np.array(df_coinc_desc.columns)

custom_thresh = 0.1
factors_thresh = get_factors(coinc_args_desc, 0.1)
factors_all = get_factors(coinc_args_desc, 1)
factors = [factors_thresh, factors_all]

fig = make_subplots(cols=2, subplot_titles=[f"Distribution for the largest {100*custom_thresh}% indices of coincidence", "Distribution for all indices of coincidence"])
xbins = go.histogram.XBins(size=1)

for i in range(2):
    hist = go.Histogram(x=factors[i], xbins=xbins)
    fig.add_trace(hist, row=1, col=i+1)

fig.update_layout(bargap=.1, height=400, width=1200, title="Density of factors in key lengths")


# %%
# create df with factors density for both threshold values
unique, counts = np.unique(factors_thresh, return_counts=True)
df_factors_density = pd.DataFrame(counts, unique, columns=[0.1])

unique, counts = np.unique(factors_all, return_counts=True)
df_factors_density[1.0] = pd.DataFrame(counts, unique, columns=[1.0])[1.0]

# most likely keys in descending order
likely_keys = df_factors_density.sort_values(0.1, ascending=False).index

# %% [markdown]
# # Using frequency analysis

# %%
def create_df_freq_letter():
    freq_eng = ['0.082', '0.015', '0.028', '0.043', '0.127', '0.022', '0.020', '0.061', '0.070', '0.002', '0.008', '0.040', '0.024', '0.067', '0.075', '0.019', '0.001', '0.060', '0.060', '0.091', '0.028', '0.010', '0.023', '0.001', '0.020', '0.001']
    freq_fra = ['0.0815', '0.0097', '0.0315', '0.0373', '0.1739', '0.0112', '0.0097', '0.0085', '0.0731', '0.0045', '0.0002', '0.0569', '0.0287', '0.0712', '0.0528', '0.0280', '0.0121', '0.0664', '0.0814', '0.0722', '0.0638', '0.0164', '0.0003', '0.0041', '0.0028', '0.0015']
    dict_freq_letter = {"freq_eng" : freq_eng, "freq_fra" : freq_fra}
    df_freq_letter = pd.DataFrame(data=dict_freq_letter, index=list(ALPHABET))
    return df_freq_letter
create_df_freq_letter()


