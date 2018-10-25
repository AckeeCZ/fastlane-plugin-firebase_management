module Fastlane
	module Actions
		class FirebaseDownloadConfigAction < Action

			def self.run(params)
				manager = Firebase::Manager.new

				# login
				api = manager.login(params[:service_account_json_path])

				# select project
				project = manager.select_project(params[:project_id])
				project_id = project["projectId"]

				# select app
				app = manager.select_app(project_id, params[:app_id])
				app_id = app["appId"]

				# download
				config = api.download_config_file(project_id, app_id)
				path = File.join(params[:output_path], params[:output_name] || config["configFilename"])

				decode_base64_content = Base64.decode64(config["configFileContents"]) 
				File.open(path, "wb") do |f|
					f.write(decode_base64_content)
				end 

				UI.success "Successfuly saved config at #{path}"

				return nil
			end

			def self.description
				"Download configuration file for Firebase app"
			end

			def self.authors
				["Ackee, s.r.o."]
			end

			def self.return_value
				# If your method provides a return value, you can describe here what it does
			end

			def self.details
				# Optional:
				"Firebase plugin helps you list your projects, create applications and download configuration files."
			end

			def self.available_options
				[
					FastlaneCore::ConfigItem.new(key: :service_account_json_path,
					                        env_name: "FIREBASE_SERVICE_ACCOUNT_JSON_PATH",
					                     description: "Path to service account json key",
					                        optional: false),
					FastlaneCore::ConfigItem.new(key: :project_id,
					                        env_name: "FIREBASE_PROJECT_ID",
					                     description: "Project id",
					                        optional: true),
					FastlaneCore::ConfigItem.new(key: :app_id,
					                        env_name: "FIREBASE_APP_ID",
					                     description: "Project app id",
					                        optional: true),
					FastlaneCore::ConfigItem.new(key: :output_path,
					                        env_name: "FIREBASE_OUTPUT_PATH",
					                     description: "Path for the downloaded config",
					                        optional: false,
					                   default_value: "./"),
					FastlaneCore::ConfigItem.new(key: :output_name,
					                        env_name: "FIREBASE_OUTPUT_NAME",
					                     description: "Name of the downloaded file",
					                        optional: true)
				]
			end

			def self.is_supported?(platform)
				# Adjust this if your plugin only works for a particular platform (iOS vs. Android, for example)
				# See: https://github.com/fastlane/fastlane/blob/master/fastlane/docs/Platforms.md
				#
				# [:ios, :mac, :android].include?(platform)
				true
			end
		end
	end
end
