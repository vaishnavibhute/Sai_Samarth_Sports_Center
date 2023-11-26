         ArrayList idarray;
        ArrayList nmarray;
        ArrayList qtyarray;
        ArrayList ratearray;
        ArrayList cntarray;
   
        float grand;
        SqlConnection cn;
        SqlCommand cmd;
        SqlDataReader dr;
        static int flag = 0;
        float gstamt = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            cn = new SqlConnection();
            cn.ConnectionString = "Data Source=SOFT-TECH;Initial Catalog=RestaurantManagementSystemDB;Integrated Security=True";
            cn.Open();
      
            idarray = new ArrayList();
            nmarray = new ArrayList();
            ratearray = new ArrayList();
            cntarray = new ArrayList();
            qtyarray = new ArrayList();
            //gstarray = new ArrayList();
            int i;
            idarray = (ArrayList)Session["idarray"];
            nmarray = (ArrayList)Session["nmarray"];
            ratearray = (ArrayList)Session["ratearray"];
            //gstarray = (ArrayList)Session["gstarray"];
            qtyarray = (ArrayList)Session["qtyarray"];
            cntarray = (ArrayList)Session["cntarray"];
            //if (nmarray.Count == 0)
            //{
            //    Button1.Enabled = false;
            //    Button2.Enabled = true;
            //}
            //else
            //{
            //    Button1.Enabled = true;
            //}
            Literal lit1, lit2, lit3, lit4;
            lit1 = new Literal();
            lit2 = new Literal();
            lit3 = new Literal();
            lit4 = new Literal();

            lit1.Text = "<Table class='table'><tr>"+
                "<td align=center><font  size=5>SR No</font></td>"+
                "<td align=center><font  size=5>Item Name</font>"+
                "</td><td align=center><font  size=5>Rate</font>"
                +"</td><td align=center><font  size=5>Qty</font>"+
                "</td> <td align=center><font  size=5>Amount</font>"
                +"</td>"
                +"<td align=center><font  size=5>Cancel</font>"
                +"</td></tr>";

            lit4.Text = "</Table>";
            float tot = 0;
            PlaceHolder1.Controls.Add(lit1);


            for (i = 0; i <= idarray.Count - 1; i++)
            {
                PlaceHolder1.Controls.Add(new LiteralControl("<tr>"));

                PlaceHolder1.Controls.Add(new LiteralControl("<td width=200 align=center>" + (i + 1)));
                PlaceHolder1.Controls.Add(new LiteralControl("</td>"));
                PlaceHolder1.Controls.Add(new LiteralControl("<td width=200 align=center>" + nmarray[i]));
                PlaceHolder1.Controls.Add(new LiteralControl("</td>"));
                PlaceHolder1.Controls.Add(new LiteralControl("<td width=200 align=center>" + ratearray[i]));
                PlaceHolder1.Controls.Add(new LiteralControl("</td>"));
                PlaceHolder1.Controls.Add(new LiteralControl("<td width=200 align=center>" + qtyarray[i]));
                PlaceHolder1.Controls.Add(new LiteralControl("</td>"));
                PlaceHolder1.Controls.Add(new LiteralControl("<td width=200 align=center>" + Convert.ToInt32(ratearray[i]) * Convert.ToInt32(qtyarray[i])));
                PlaceHolder1.Controls.Add(new LiteralControl("</td>"));

             //   PlaceHolder1.Controls.Add(new LiteralControl("<td width=200 align=center>" + gstarray[i]));
                PlaceHolder1.Controls.Add(new LiteralControl("</td>"));
                float amt=(Convert.ToInt32(ratearray[i]) * Convert.ToInt32(qtyarray[i]));
               gstamt = (Convert.ToSingle(amt * 5))/ 100.0f;
              Session["gst"] = gstamt;
                //PlaceHolder1.Controls.Add(new LiteralControl("<td width=200 align=center>" + gstamt));
                PlaceHolder1.Controls.Add(new LiteralControl("</td>"));

                PlaceHolder1.Controls.Add(new LiteralControl("</td>"));
                PlaceHolder1.Controls.Add(new LiteralControl("<td width=200 align=center><a href='Search/CancelCartItem.aspx?ID=" + (i) + "'>Cancel</a>"));

                PlaceHolder1.Controls.Add(new LiteralControl("</td>"));
                PlaceHolder1.Controls.Add(new LiteralControl("</tr>"));
                tot += amt;// Convert.ToInt32(ratearray[i]) * Convert.ToInt32(qtyarray[i]);
            }

            Session["total"] = tot;
            PlaceHolder1.Controls.Add(new LiteralControl("<tr>"));
            PlaceHolder1.Controls.Add(new LiteralControl("<td colspan=4 width=200 align=right><font  size=5>GST(18%)  </font>"));
            gstamt = Convert.ToInt32(((tot * 18.0) / 100));
            PlaceHolder1.Controls.Add(new LiteralControl("</td><td width=200 align=left><font  size=5>" + gstamt + "</font>"));
            PlaceHolder1.Controls.Add(new LiteralControl("</td></tr>"));

            PlaceHolder1.Controls.Add(new LiteralControl("<tr>"));
            PlaceHolder1.Controls.Add(new LiteralControl("<td colspan=4 width=200 align=right><font  size=5>Grand Total  </font>"));
            grand = tot+gstamt;// Convert.ToInt32(tot + ((tot * 14.0) / 100));
            PlaceHolder1.Controls.Add(new LiteralControl("</td><td width=200 align=left><font  size=5>" + grand + "</font>"));
            PlaceHolder1.Controls.Add(new LiteralControl("</td></tr>"));
            Session.Add("grand", grand);


            PlaceHolder1.Controls.Add(lit4);
        }

        protected void Button1_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Customer_Login.aspx");
        }

        protected void Button3_Click(object sender, EventArgs e)
        {
            
        }

        protected void Button2_Click(object sender, EventArgs e)
        {
        }

        protected void Button1_Click1(object sender, EventArgs e)
        {

            Response.Redirect("~/Search/SearchFood.aspx");
        }

        protected void Button3_Click1(object sender, EventArgs e)
        {
            nmarray.Clear();
            idarray.Clear();
            cntarray.Clear();
            qtyarray.Clear();
            ratearray.Clear();
            Response.Redirect("~/Form_Bill.aspx");

        }

        public int GetNewOrdID()
        {
            cmd = new SqlCommand();
            cmd.Connection = cn;
            cmd.CommandText = "select max (orderid) from OrderMaster";
            object x = cmd.ExecuteScalar();

            if (Convert.ToString(x) == "")
                return 1;
            else
                return (Convert.ToInt32(x) + 1);
        }
        protected void Button2_Click1(object sender, EventArgs e)
        {

            int i, amt, ord_id;
            double gst;

            ord_id = GetNewOrdID();
            cmd = new SqlCommand();
            Session["ordid"] = ord_id;
            cmd.Connection = cn;
            cmd.CommandText = "insert into Ordermaster values(" 
                + ord_id + ",'" + Session["cid"] + "','" 
                + System.DateTime.Now.ToString() + "'," 
                + Session["total"] + "," + Session["gst"] + "," + Session["grand"] + ")";
            cmd.ExecuteNonQuery();
            MessageBox.Show("Order Inserted");


            for (i = 0; i <= cntarray.Count - 1; i++)
            {

                amt = Convert.ToInt32(ratearray[i]) * Convert.ToInt32(qtyarray[i]);
                cmd = new SqlCommand();

                cmd.Connection = cn;
                cmd.CommandText = "insert into Orderdetail values(" 
                    + (i+1) 
                    + ",'" + ord_id 
                    + "','" + idarray[i] 
                    + "'," + ratearray[i] + "," 
                    + qtyarray[i] + "," 
                    + amt + ")";
                cmd.ExecuteNonQuery();
                MessageBox.Show("Order Details Inserted");
                //l1.Updaterecord("update product_master set product_stock=product_stock-" + qtyarray[i] + " where product_nm='" + nmarray[i] + "'");
            }






            Response.Redirect("~/Form_receipt.aspx");

        }

        }
    }
