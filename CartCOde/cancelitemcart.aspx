 ArrayList idarray = new ArrayList();
        ArrayList nmarray = new ArrayList();
        ArrayList qtyarray = new ArrayList();
        ArrayList ratearray = new ArrayList();
        ArrayList cntarray = new ArrayList();
        ArrayList  gstarray = new ArrayList();
        protected void Page_Load(object sender, EventArgs e)
        {
            cntarray = (ArrayList)Session["cntarray"];
            idarray = (ArrayList)Session["idarray"];
            nmarray = (ArrayList)Session["nmarray"];
            ratearray = (ArrayList)Session["ratearray"];
            qtyarray = (ArrayList)Session["qtyarray"];
            gstarray = (ArrayList)Session["gstarray"];


            if (Request.QueryString.ToString() != null)
            {
                int id = Convert.ToInt32(Request.QueryString["ID"]); //, Globalization.NumberStyles.Integer)

                cntarray.RemoveAt(id);
                idarray.RemoveAt(id);
                nmarray.RemoveAt(id);
                ratearray.RemoveAt(id);
                qtyarray.RemoveAt(id);
               gstarray.RemoveAt(id);

            }
            if (cntarray.Count == 0)
            {
                //Web_Fashion_line.Customer.web_item_details.cnt = 0;
            }



            Response.Redirect("~/Customer/viewbill.aspx");
        

        }
