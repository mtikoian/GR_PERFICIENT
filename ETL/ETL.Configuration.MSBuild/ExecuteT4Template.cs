using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Microsoft.Build.Utilities;
using Microsoft.Build.Framework;
using System.IO;
using Microsoft.VisualStudio.TextTemplating;
using System.CodeDom.Compiler;

namespace ETL.Configuration.MSBuild
{
    /// <summary>
    /// Executes the T4 template provided, replacing any MSBuild property
    /// and item group markers with their runtime values
    /// </summary>
    public class ExecuteT4Template : Task
    {
        #region Fields

        private ITaskItem _DestinationDirectory;
        private ITaskItem[] _SourceFiles;

        #endregion

        #region Properties

        /// <summary>
        /// Gets or sets the destination files.
        /// </summary>
        /// <value>The destination files.</value>
        public ITaskItem DestinationDirectory
        {
            get
            {
                return this._DestinationDirectory;
            }
            set
            {
                this._DestinationDirectory = value;
            }
        }

        /// <summary>
        /// Gets or sets the source files.
        /// </summary>
        /// <value>The source files.</value>
        public ITaskItem[] SourceFiles
        {
            get
            {
                return this._SourceFiles;
            }
            set
            {
                this._SourceFiles = value;
            }
        }

        #endregion

        #region Methods

        /// <summary>
        /// Executes the build tast to generate the T4 Templates.
        /// </summary>
        /// <returns>True if the task succeeded otherwise false.</returns>
        public override bool Execute()
        {
            try
            {
                //Check that there are source files
                if ((this._SourceFiles == null) || (this._SourceFiles.Length == 0))
                {
                    base.Log.LogError("No SourceFiles provided", new object[0]);
                    return false;
                }

                string projectPath = Environment.CurrentDirectory;

                if (!projectPath.EndsWith(@"\"))
                {
                    projectPath += @"\";
                }

                string destinationPath = projectPath + this.DestinationDirectory.ItemSpec;

                //Process each file
                for (int i = 0; i < this._SourceFiles.Length; i++)
                {
                    ITaskItem sourceFile = this._SourceFiles[i];

                    //Check the source file exists
                    if (!File.Exists(sourceFile.ItemSpec))
                    {
                        base.Log.LogError("Could not find source file '" + sourceFile.ItemSpec + "'", new object[0]);
                        return false;
                    }

                    string commandSourceFile = projectPath + sourceFile.ItemSpec;

                    string commandDestinationFile = Path.GetFileNameWithoutExtension(destinationPath + sourceFile.ItemSpec);
                    commandDestinationFile = Path.Combine(Path.GetDirectoryName(destinationPath + sourceFile.ItemSpec), commandDestinationFile);

                    //Generate the file
                    ProcessTemplate(commandSourceFile, commandDestinationFile);
                }
                return true;
            }
            catch (Exception exception)
            {
                base.Log.LogErrorFromException(exception);
                return false;
            }

        }

        void ProcessTemplate(string templateFileName, string outputFileName)
        {
            CustomTextTemplateHost host = new CustomTextTemplateHost();
            Engine engine = new Engine();

            host._TemplateFileValue = templateFileName;

            //Read the text template.
            string input = File.ReadAllText(templateFileName);

            //Transform the text template.
            string output = engine.ProcessTemplate(input, host);

            outputFileName = outputFileName + host.FileExtension;

            if (!Directory.Exists(Path.GetDirectoryName(outputFileName)))
            {
                Directory.CreateDirectory(Path.GetDirectoryName(outputFileName));
            }

            File.WriteAllText(outputFileName, output, host.FileEncoding);

            foreach (CompilerError error in host.Errors)
            {
                this.Log.LogError(error.ToString());
            }
        }

        #endregion
    }
}
