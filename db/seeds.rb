# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
# 既存データを削除
Notification.destroy_all
Application.destroy_all
Task.destroy_all
User.destroy_all
Organization.destroy_all

# Organizations
org1 = Organization.create!(name: "NPO Community")
org2 = Organization.create!(name: "Local Volunteer Group")

# Users
user1 = User.create!(
  name: "Alice",
  mail_address: "alice@example.com",
  role: "admin",
  organization_id: org1.id,
  password: "password"
)

user2 = User.create!(
  name: "Bob",
  mail_address: "bob@example.com",
  role: "supporter",
  organization_id: org1.id,
  password: "password"
)

user3 = User.create!(
  name: "Charlie",
  mail_address: "charlie@example.com",
  role: "supporter",
  organization_id: org2.id,
  password: "password"
)

# Tasks
task1 = Task.create!(
  title: "Community Cleanup",
  description: "Help clean up the local park.",
  apply_deadline: Date.today + 7.days,
  required_number_of_people: 5,
  status: "募集中",
  organization_id: org1.id
)

task2 = Task.create!(
  title: "Charity Event Setup",
  description: "Assist with setting up the event venue.",
  apply_deadline: Date.today + 10.days,
  required_number_of_people: 3,
  status: "募集中",
  organization_id: org2.id
)

# Applications
app1 = Application.create!(
  task_id: task1.id,
  supporter_id: user2.id,
  application_status: "応募",
  request_status: "依頼",
  comment_supporter: "週末空いてます.",
  comment_organization: "是非お願いします",
  experience: "経験有",
  uptime: 4
)
