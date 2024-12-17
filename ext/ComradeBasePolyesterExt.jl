module ComradeBasePolyesterExt
using ComradeBase
using Polyester: @batch

const PolyThreads = ComradeBase.ThreadsEx{:Polyester}


function ComradeBase.intensitymap_analytic!(img::IntensityMap{T,N,D,
                                                              <:ComradeBase.AbstractRectiGrid{D,
                                                                                              <:PolyThreads}},
                                            s::ComradeBase.AbstractModel) where {T,N,D}
    dx, dy = ComradeBase.pixelsizes(img)
    g = ComradeBase.domainpoints(img)
    f = Base.Fix1(ComradeBase.intensity_point, s)
    pimg = parent(img)
    @batch for I in CartesianIndices(pimg)
        pimg[I] = f(g[I]) * dx * dy
    end
    return nothing
end

function ComradeBase.intensitymap_analytic!(img::UnstructuredMap{T,N,
                                                                 <:ComradeBase.UnstructuredDomain{D,
                                                                                                  <:PolyThreads}},
                                            s::ComradeBase.AbstractModel) where {T,N,D}
    g = ComradeBase.domainpoints(img)
    f = Base.Fix1(ComradeBase.intensity_point, s)
    pimg = parent(img)
    @batch for I in CartesianIndices(pimg)
        pimg[I] = f(g[I])
    end
    return nothing
end

function ComradeBase.visibilitymap_analytic!(vis::ComradeBase.FluxMap2{T,N,
                                                                       <:ComradeBase.AbstractSingleDomain{<:Any,
                                                                                                          <:PolyThreads}},
                                             s::ComradeBase.AbstractModel) where {T,N}
    dims = axisdims(vis)
    g = domainpoints(dims)
    f = Base.Fix1(ComradeBase.visibility_point, s)
    pvis = parent(vis)
    @batch for I in CartesianIndices(g)
        pvis[I] = f(g[I])
    end
    return nothing
end

end
