void getFromE(ref@ _tags){
    jsonResult = Json::Parse('{"loading" : true}');
    auto tagsc = cast<Tags>(_tags);
    auto req = Net::HttpRequest();
    req.Method = Net::HttpMethod::Get;
    req.Url = "https://e621.net/posts.json?limit=" + Query_searchLimit +"&tags=-animated+" + tagsc.toUrl();
    req.Start();
    while (!req.Finished()) {
        yield();
    }
    jsonResult = Json::Parse(req.String());
    jsonResult['loading'] = false;
}