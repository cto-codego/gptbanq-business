
class SendNetwork {
    SendNetwork({
        this.status,
        this.network,
    });

    int ?status;
    List<Network> ?network;

    factory SendNetwork.fromJson(Map<String, dynamic> json) => SendNetwork(
        status: json["status"],
        network: List<Network>.from(json["network"].map((x) => Network.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "network": List<dynamic>.from(network!.map((x) => x.toJson())),
    };
}

class Network {
    Network({
        this.network,
        this.networkName,
    });

    String? network;
    String ?networkName;

    factory Network.fromJson(Map<String, dynamic> json) => Network(
        network: json["network"],
        networkName: json["network_name"],
    );

    Map<String, dynamic> toJson() => {
        "network": network,
        "network_name": networkName,
    };
}
