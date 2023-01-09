string getFromE(string tags, int limit=10){
    auto req = Net::HttpRequest();
    req.Method = Net::HttpMethod::Get;
    req.Url = "https://e621.net/posts.json?limit=" + limit +"&tags=" + tags;
    req.Start();
    while (!req.Finished()) {
        yield();
    }
    return req.String();
}