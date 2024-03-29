﻿#pragma warning disable 1591
//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//     Runtime Version:2.0.50727.3603
//
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace PrototypeDrilldown
{
	using System.Data.Linq;
	using System.Data.Linq.Mapping;
	using System.Data;
	using System.Collections.Generic;
	using System.Reflection;
	using System.Linq;
	using System.Linq.Expressions;
	using System.ComponentModel;
	using System;
	
	
	[System.Data.Linq.Mapping.DatabaseAttribute(Name="GrReportingComments")]
	public partial class GrReportingCommentsDataContext : System.Data.Linq.DataContext
	{
		
		private static System.Data.Linq.Mapping.MappingSource mappingSource = new AttributeMappingSource();
		
    #region Extensibility Method Definitions
    partial void OnCreated();
    partial void InsertReportComment(ReportComment instance);
    partial void UpdateReportComment(ReportComment instance);
    partial void DeleteReportComment(ReportComment instance);
    #endregion
		
		public GrReportingCommentsDataContext() : 
				base(global::System.Configuration.ConfigurationManager.ConnectionStrings["GrReportingCommentsConnectionString"].ConnectionString, mappingSource)
		{
			OnCreated();
		}
		
		public GrReportingCommentsDataContext(string connection) : 
				base(connection, mappingSource)
		{
			OnCreated();
		}
		
		public GrReportingCommentsDataContext(System.Data.IDbConnection connection) : 
				base(connection, mappingSource)
		{
			OnCreated();
		}
		
		public GrReportingCommentsDataContext(string connection, System.Data.Linq.Mapping.MappingSource mappingSource) : 
				base(connection, mappingSource)
		{
			OnCreated();
		}
		
		public GrReportingCommentsDataContext(System.Data.IDbConnection connection, System.Data.Linq.Mapping.MappingSource mappingSource) : 
				base(connection, mappingSource)
		{
			OnCreated();
		}
		
		public System.Data.Linq.Table<ReportComment> ReportComments
		{
			get
			{
				return this.GetTable<ReportComment>();
			}
		}
	}
	
	[Table(Name="dbo.ReportComment")]
	public partial class ReportComment : INotifyPropertyChanging, INotifyPropertyChanged
	{
		
		private static PropertyChangingEventArgs emptyChangingEventArgs = new PropertyChangingEventArgs(String.Empty);
		
		private int _ReportCommentId;
		
		private string _GlAccountCode;
		
		private int _ReportPeriod;
		
		private string _Comment;
		
		private System.Data.Linq.Binary _Version;
		
    #region Extensibility Method Definitions
    partial void OnLoaded();
    partial void OnValidate(System.Data.Linq.ChangeAction action);
    partial void OnCreated();
    partial void OnReportCommentIdChanging(int value);
    partial void OnReportCommentIdChanged();
    partial void OnGlAccountCodeChanging(string value);
    partial void OnGlAccountCodeChanged();
    partial void OnReportPeriodChanging(int value);
    partial void OnReportPeriodChanged();
    partial void OnCommentChanging(string value);
    partial void OnCommentChanged();
    partial void OnVersionChanging(System.Data.Linq.Binary value);
    partial void OnVersionChanged();
    #endregion
		
		public ReportComment()
		{
			OnCreated();
		}
		
		[Column(Storage="_ReportCommentId", AutoSync=AutoSync.OnInsert, DbType="Int NOT NULL IDENTITY", IsPrimaryKey=true, IsDbGenerated=true, UpdateCheck=UpdateCheck.Never)]
		public int ReportCommentId
		{
			get
			{
				return this._ReportCommentId;
			}
			set
			{
				if ((this._ReportCommentId != value))
				{
					this.OnReportCommentIdChanging(value);
					this.SendPropertyChanging();
					this._ReportCommentId = value;
					this.SendPropertyChanged("ReportCommentId");
					this.OnReportCommentIdChanged();
				}
			}
		}
		
		[Column(Storage="_GlAccountCode", DbType="Char(12) NOT NULL", CanBeNull=false, UpdateCheck=UpdateCheck.Never)]
		public string GlAccountCode
		{
			get
			{
				return this._GlAccountCode;
			}
			set
			{
				if ((this._GlAccountCode != value))
				{
					this.OnGlAccountCodeChanging(value);
					this.SendPropertyChanging();
					this._GlAccountCode = value;
					this.SendPropertyChanged("GlAccountCode");
					this.OnGlAccountCodeChanged();
				}
			}
		}
		
		[Column(Storage="_ReportPeriod", DbType="Int NOT NULL", UpdateCheck=UpdateCheck.Never)]
		public int ReportPeriod
		{
			get
			{
				return this._ReportPeriod;
			}
			set
			{
				if ((this._ReportPeriod != value))
				{
					this.OnReportPeriodChanging(value);
					this.SendPropertyChanging();
					this._ReportPeriod = value;
					this.SendPropertyChanged("ReportPeriod");
					this.OnReportPeriodChanged();
				}
			}
		}
		
		[Column(Storage="_Comment", DbType="VarChar(MAX) NOT NULL", CanBeNull=false, UpdateCheck=UpdateCheck.Never)]
		public string Comment
		{
			get
			{
				return this._Comment;
			}
			set
			{
				if ((this._Comment != value))
				{
					this.OnCommentChanging(value);
					this.SendPropertyChanging();
					this._Comment = value;
					this.SendPropertyChanged("Comment");
					this.OnCommentChanged();
				}
			}
		}
		
		[Column(Storage="_Version", AutoSync=AutoSync.Always, DbType="rowversion NOT NULL", CanBeNull=false, IsDbGenerated=true, IsVersion=true, UpdateCheck=UpdateCheck.Never)]
		public System.Data.Linq.Binary Version
		{
			get
			{
				return this._Version;
			}
			set
			{
				if ((this._Version != value))
				{
					this.OnVersionChanging(value);
					this.SendPropertyChanging();
					this._Version = value;
					this.SendPropertyChanged("Version");
					this.OnVersionChanged();
				}
			}
		}
		
		public event PropertyChangingEventHandler PropertyChanging;
		
		public event PropertyChangedEventHandler PropertyChanged;
		
		protected virtual void SendPropertyChanging()
		{
			if ((this.PropertyChanging != null))
			{
				this.PropertyChanging(this, emptyChangingEventArgs);
			}
		}
		
		protected virtual void SendPropertyChanged(String propertyName)
		{
			if ((this.PropertyChanged != null))
			{
				this.PropertyChanged(this, new PropertyChangedEventArgs(propertyName));
			}
		}
	}
}
#pragma warning restore 1591
