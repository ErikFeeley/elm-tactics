module Request.Helpers exposing (apiUrl)


apiUrl : String -> String
apiUrl str =
    "http://ec2-18-191-140-179.us-east-2.compute.amazonaws.com:13370/api" ++ str
