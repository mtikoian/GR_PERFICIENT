using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

namespace PrototypeDrilldown
{
    public partial class DrilldownComment : System.Web.UI.Page
    {
        public string GlAccountCode { get; set; }
        public int ReportPeriod { get; set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!String.IsNullOrEmpty(Request.QueryString["GlAccountCode"]))
            {
                GlAccountCode = Request.QueryString["GlAccountCode"];
            }

            if (!String.IsNullOrEmpty(Request.QueryString["ReportPeriod"]))
            {
                ReportPeriod =  int.Parse(Request.QueryString["ReportPeriod"]);
            }

            if (!this.IsPostBack)
            {
                GlAccountLiteral.Text = GlAccountCode;
                ReportPeriodLiteral.Text = ReportPeriod.ToString();
                
                GrReportingCommentsDataContext db = new GrReportingCommentsDataContext();
                ReportComment reportComment = db.ReportComments.FirstOrDefault(p => p.GlAccountCode == GlAccountCode && p.ReportPeriod == ReportPeriod);
                if (reportComment != null)
                {
                    CommentTextBox.Text = reportComment.Comment;
                    ViewState.Add("ReportCommentId", reportComment.ReportCommentId);
                }                
            }
        }

        protected void SaveButton_Click(object sender, EventArgs e)
        {
            if (!String.IsNullOrEmpty(CommentTextBox.Text))
            {
                GrReportingCommentsDataContext db = new GrReportingCommentsDataContext();
                ReportComment reportComment;

                if (ViewState["ReportCommentId"] == null)
                {
                    reportComment = new ReportComment();
                    reportComment.GlAccountCode = GlAccountCode;
                    reportComment.ReportPeriod = ReportPeriod;
                    reportComment.Comment = CommentTextBox.Text;
                    db.ReportComments.InsertOnSubmit(reportComment);
                }
                else
                {
                    reportComment = db.ReportComments.FirstOrDefault(p => p.ReportCommentId == (int)ViewState["ReportCommentId"]);
                    reportComment.Comment = CommentTextBox.Text;
                }

                db.SubmitChanges();
            }

        }

    }
}
