module NerscClusterManagers

using Random
import ClusterManagers: ElasticManager, IPv4

export ElasticManager

function ElasticManager(::Val{:nersc}; port=12345)
    ip = strip(read(`hostname --ip-address`, String))
    cookie = randstring(16)
    
    println("To connect workers:")
    println("julia -e 'using ClusterManagers; ClusterManagers.elastic_worker(\"$cookie\",\"$ip\",$port)'")
    
    ElasticManager(addr=IPv4(ip), port=port, cookie=cookie)
end

end
