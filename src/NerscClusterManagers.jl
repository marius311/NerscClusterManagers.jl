module NerscClusterManagers

using Random
import ClusterManagers: ElasticManager, IPv4

export ElasticManager

function ElasticManager(::Val{:nersc}; port=0)
    ip = strip(read(`hostname --ip-address`, String))
    cookie = randstring(16)
    
    em = ElasticManager(addr=IPv4(ip), port=port, cookie=cookie)
    port = convert(Int,em.sockname[2]) # port could be ephemeral, so read it again here
    
    println("To connect workers:")
    println("julia -e 'using ClusterManagers; ClusterManagers.elastic_worker(\"$cookie\",\"$ip\",$port)'")
    
    em
end

end
