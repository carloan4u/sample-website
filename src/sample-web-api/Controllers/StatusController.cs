﻿using System.Net;
using System.Web.Http;

namespace sample_website.Controllers
{
    public class StatusController : ApiController
    {
        public dynamic Get()
        {
            return new
            {
                Status = HttpStatusCode.OK
            };
        }
    }
}
