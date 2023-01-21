module.exports = {
  plugins: [
    [
      "@semantic-release/commit-analyzer",
      {
        preset: "angular",
        releaseRules: [
          { tag: "breaking", release: "major" },
          { tag: "chore", release: false },
          { tag: "ci", release: false },
          { tag: "docs", release: false },
          { tag: "feat", release: "minor" },
          { tag: "fix", release: "patch" },
          { tag: "refactor", release: "patch" },
          { tag: "security", release: "patch" },
          { tag: "style", release: "patch" },
          { tag: "test", release: false },
        ],
      },
    ],
    [
      "@semantic-release/release-notes-generator",
      {
        preset: "angular",
        releaseRules: [
          { tag: "breaking", release: "major" },
          { tag: "chore", release: false },
          { tag: "ci", release: false },
          { tag: "docs", release: false },
          { tag: "feat", release: "minor" },
          { tag: "fix", release: "patch" },
          { tag: "refactor", release: "patch" },
          { tag: "security", release: "patch" },
          { tag: "style", release: "patch" },
          { tag: "test", release: false },
        ],
      },
    ],
    [
      "@semantic-release/changelog",
      {
        changelogFile: "CHANGELOG.md",
      },
    ],
    [
      "semantic-release-rubygem",
      {
        gemFileDir: './',
        updateGemfileLock: true,
      }
    ],
    [
      "@semantic-release/git",
      {
        assets: ["CHANGELOG.md", "lib/fastlane/plugin/firebase_test_lab_integration/version.rb"],
        message: "chore(release): ${nextRelease.version} [skip ci]",
      }
    ],
    [
      "@semantic-release/github",
      {
        assets: [
          { path: ".", label: "src" }
        ]
      }
    ]
  ],
  branches: [
    {
      name: "main",
    }
  ],
};
