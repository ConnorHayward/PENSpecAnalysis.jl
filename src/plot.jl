# Part of PENSpecAnalysis.jl module.


"""
plot_emission_spectra(dict::OrderedDict,fit=false)

Produce plots of each spectra in given Dict.

Plot can optionally contain peak wavelength and chi2 of fit.
"""
function plot_emission_spectra(dict::OrderedDict,fit=false)
    plt = plot(bg=:white)
    for key in keys(dict)
        h = read_spec_data(dict[key])
        plot!(plt, h,label="$key",st=:step)

        if fit
            fitting = peakfit(h)
            peak_val = Measurements.value(fitting[1])
            peak_unc = Measurements.uncertainty(fitting[1])
            scatter!(plt,[peak_val],[Measurements.value(fitting[2](fitting[1]))],xlims=[h.edges[1][1]+10,h.edges[1][end]-10],label="$(@sprintf("%0.2f",peak_val)) ± $(@sprintf("%0.2f",peak_unc)) nm")
            plot!(plt,fitting[2],[peak_val-5:peak_val+5],label="Fit \chi^2 = $(@sprintf("%0.2f",fitting[3]))")
        end
    end
 return plt

end

export plot_emission_spectra

"""
plot_norm_emission_spectra(dict::OrderedDict,fit=false)

Produce plots of each spectra in given Dict.

Plot can optionally contain peak wavelength and chi2 of fit.

# Arguements
- 'mode' = normalization setting to be used. If height, histogram normallized to highest weight. If area, normalized so norm(h)=1.
"""
function plot_norm_emission_spectra(dict::OrderedDict,fit=false; mode="height")
    plt = plot(bg=:white)
    for key in keys(dict)
        h = read_spec_data(dict[key])

        if mode == "height"
            h.weights = h.weights./maximum(h.weights)
        end

        if mode =="area"
            h.weights = h.weights./norm(h)
        end

        plot!(plt, h,label="$key",st=:step)
        if fit
            fitting = peakfit(h)
            peak_val = Measurements.value(fitting[1])
            peak_unc = Measurements.uncertainty(fitting[1])
            scatter!(plt,[peak_val],[Measurements.value(fitting[2](fitting[1]))],xlims=[h.edges[1][1]+10,h.edges[1][end]-10],label="$(@sprintf("%0.2f",peak_val)) ± $(@sprintf("%0.2f",peak_unc)) nm")
            plot!(plt,fitting[2],[peak_val-5:peak_val+5],label="Fit \chi^2 = $(@sprintf("%0.2f",fitting[3]))")
        end
    end
 return plt

end

export plot_norm_emission_spectra