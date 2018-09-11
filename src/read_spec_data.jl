# Compute StatsBase Histogram from raw spectrometer output.

"""
read_spec_data(filename::String)

Reads input csv datafile from ANDOR Spectrometer into StatsBase histogram for analysis.

# Arguements
- 'filename::String': Spectrometer data file to be opened.

# Returns
- 'h::Histogram': Histogram of data.
"""
function read_spec_data(filename::String)
    f = open(filename)
    data = readdlm(IOBuffer(readstring(f)),',')

    try
        data = data[1:end,1:2]
    catch
        println("Error Check")
        data = readdlm(IOBuffer(readstring(f)),'\t')
        data = data[1:end,1:2]
    end

    edge_vec = [0.5 * (data[:,1][i] + data[:,1][i + 1]) for i = 1:length(data[:,1]) - 1]
    unshift!(edge_vec, data[:,1][1]-(data[:,1][2]-data[:,1][1])/2)
    append!(edge_vec, data[:,1][end]+(data[:,1][end]-data[:,1][end-1])/2)

    h = fit(Histogram, float.(data[1:end,1]),weights(float.(data[1:end,2])),edge_vec,closed=:left)
    return h
end

export read_spec_data

"""
read_spec_data(filename::String, format::Bool; Bkg=0)

Reads input csv datafile from ANDOR Spectrometer into StatsBase histogram for analysis or in x and y arrays.

# Arguements
- 'filename::String': Spectrometer data file to be opened.
- 'format::Bool': false returns the histogram as in the function above and true the data arrays
- 'Bkg': Optionally the background can be subtracted

# Returns
- 'h::Histogram': Histogram of data.
- 'x,y': Data in two arrays
"""


# function read_spec_data(filename::String, format::Bool; bkg=0)
#
#     f = open(filename)
#     data = readdlm(IOBuffer(readstring(f)),',')
#     data = data[1:end,1:2]
#
#     edge_vec = [0.5 * (data[:,1][i] + data[:,1][i + 1]) for i = 1:length(data[:,1]) - 1]
#     unshift!(edge_vec, data[:,1][1]-(data[:,1][2]-data[:,1][1])/2)
#     append!(edge_vec, data[:,1][end]+(data[:,1][end]-data[:,1][end-1])/2)
#         x = float.(data[1:end,1])
#     # if bkg == 0
#     #     y = float.(data[1:end,2])
#     # elseif typeof(bkg) == Float64
#     #     y = float.(data[1:end,2]).-bkg
#     # else
#     #     y = float.(data[1:end,2]).-float(mean(bkg[2]))
#     # end
#     # if format
#     #     return x,y
#     # else
#     #     h = fit(Histogram, x, weights(y), edge_vec, closed=:left)
#     #     return h
#     # end
# end

function remove_background!(h::Histogram, bkg::Float64)
    h.weights = h.weights .- bkg
end

function remove_background!(h::Histogram, bkg::Histogram)
    h.weights = h.weights .- mean(bkg.weights)
end


export remove_background!
