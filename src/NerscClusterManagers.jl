module NerscClusterManagers

using Random
using Pkg
import ClusterManagers: ElasticManager, IPv4

export ElasticManager

function ElasticManager(::Val{:nersc}; port=rand(32768:61000))
    ip = strip(read(`hostname --ip-address`, String))
    cookie = randstring(16)
    
    println("To connect workers:")
    
    exename = joinpath(Sys.BINDIR, Base.julia_exename())
    project = Pkg.API.Context().env.project_file
    println("$exename --project=$project -e 'using ClusterManagers; ClusterManagers.elastic_worker(\"$cookie\",\"$ip\",$port)'")
    
    
    ElasticManager(addr=IPv4(ip), port=port, cookie=cookie)
end

end
