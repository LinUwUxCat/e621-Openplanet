void getFromE(ref@ _tags){
    auto tagsc = cast<Tags>(_tags);
    auto req = Net::HttpRequest();
    req.Method = Net::HttpMethod::Get;
    req.Headers['User-Agent'] = "e621 Browser For Openplanet/0.0 by LinuxCat (#1504 on Discord)";
    string baseUrl = "https://e" + (is926?"926":"621") + ".net/";
    req.Url = baseUrl + "posts.json?limit=" + Query_searchLimit + "&page=" + tagsc.page + "&tags=-animated+" + tagsc.toUrl();
    req.Start();
    loading = true;
    while (!req.Finished()) {
        yield();
    }
    jsonResult = Json::Parse(req.String());
    if (jsonResult == null || jsonResult.GetType() == Json::Type::Null){
        maintenance = true;
    }

    loading = false;
    
}