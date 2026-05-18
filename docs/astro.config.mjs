import starlight from "@astrojs/starlight";
import { defineConfig } from "astro/config";
import starlightTypeDoc, { typeDocSidebarGroup } from "starlight-typedoc";
import starlightVersions from "starlight-versions";

export default defineConfig({
  site: "https://axiomantic.github.io",
  base: "/project-name",
  integrations: [
    starlight({
      title: "project-name",
      description: "TODO: project tagline",
      social: [
        {
          icon: "github",
          label: "GitHub",
          href: "https://github.com/axiomantic/project-name",
        },
      ],
      editLink: {
        baseUrl: "https://github.com/axiomantic/project-name/edit/main/docs/",
      },
      plugins: [
        starlightTypeDoc({
          entryPoints: ["../src/index.ts"],
          tsconfig: "../tsconfig.json",
          output: "reference/api",
        }),
        starlightVersions({
          versions: [{ slug: "0.0" }],
        }),
      ],
      sidebar: [
        { label: "Guides", items: [{ autogenerate: { directory: "guides" } }] },
        {
          label: "Reference",
          items: [{ label: "Overview", link: "/reference/overview/" }, typeDocSidebarGroup],
        },
      ],
    }),
  ],
});
