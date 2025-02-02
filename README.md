# Why Donors Donate replication code


- [Getting started](#getting-started)
- [Method 1: Docker Compose
  (recommended)](#method-1-docker-compose-recommended)
- [Method 2: {renv} locally](#method-2-renv-locally)

<!-- README.md is generated from README.qmd. Please edit that file -->
This is a Docker container to help with the replication of [“Why Donors
donate”](https://github.com/andrewheiss/silent-skywalk)

------------------------------------------------------------------------

To maximize replicability, we wrote the manuscript using
[Quarto](https://quarto.org/), which allowed us to mix computational
figures, text, and tables with the actual prose of the manuscript. This
means that there’s no need to rely on comments within code to identify
the location of each appropriate result in the manuscript—all results
are programmatically included when rendering the document.

We use the [{renv}
package](https://rstudio.github.io/renv/articles/renv.html) to create a
stable version-specific library of R packages, and we use the [{targets}
package](https://docs.ropensci.org/targets/index.html) to manage all the
file dependencies and run the analysis. {targets} is especially helpful
with long-running objects like the main model, which takes 20–30 minutes
to run—as long as upstream dependencies don’t change, the model only
needs to run once, and can be loaded from {targets}’s data store
thereafter.

Because it can sometimes be difficult to set up and configure
version-specific libraries of R packages and install specific versions
of Stan, we provide two methods for replicating our analysis: (1) a
Docker container built and orchestrated with Docker Compose, or (2)
restoring a {renv} environment on your local computer.

The data for the analysis is accessible in
`silent-skywalk/data/raw_data`. The {targets} pipeline cleans this data
and creates an object named `data_full`—load it into an R session with
`targets::tar_load(data_full)`.

------------------------------------------------------------------------

The complete {targets} pipeline generates two output artifacts:

- **Manuscript**: An HTML version of the manuscript and appendix,
  located at `silent-skywalk/manuscript/output/manuscript.html` (or at
  `http://localhost:8888/notebook/manuscript.html` if you run the
  pipeline with Docker Compose).
- **Analysis notebook**: A static website containing more complete
  details about the survey, experiment design, preregistration,
  statistical methods and other information, located at
  `silent-skywalk/_site` (or at `http://localhost:8888` if you run the
  pipeline with Docker Compose).

## Getting started

The repository for the paper itself is accessible at
<https://github.com/andrewheiss/silent-skywalk> and should be cloned
into this repository into a folder named `silent-skywalk`. You can
either download the repository from GitHub or run this command in the
terminal:

``` sh
git clone https://github.com/andrewheiss/silent-skywalk.git
```

Make sure the folder structure looks like this:

``` text
.
├── README.md
├── README.pdf
├── docker-compose.yml
├── Dockerfile
├── ...
├── img/
├── ...
└── silent-skywalk
    ├── README.md
    ├── silent-skywalk.Rproj
    └── ...
```

## Method 1: Docker Compose (recommended)

The entire analysis can be run in a Docker container based on R 4.3.3,
with all packages locked at specific versions defined in
`silent-skywalk/renv.lock`.

Here’s how to do this:

1.  Install Docker Desktop on your computer (instructions for
    [macOS](https://docs.docker.com/desktop/install/mac-install/) or
    [Windows](https://docs.docker.com/desktop/install/windows-install/)).

2.  Make sure Docker is running.

3.  In the Docker Desktop settings, make sure you allocate at least 8
    CPUs and 16 GB of RAM.

    <img src="img/docker-resources.png" style="width:90.0%"
    alt="Docker Desktop resource settings" />

4.  Build the analysis with Docker Compose. There are two general
    approaches:

    - **Using Visual Studio Code *(recommended)***: If you [download
      Visual Studio Code](https://code.visualstudio.com/) and [its
      Docker
      extension](https://code.visualstudio.com/docs/containers/overview),
      you can right click on the `docker-compose.yml` file in the File
      Explorer sidebar and select “Compose Up”.

      <img src="img/docker-compose-sidebar.png" style="width:60.0%"
      alt="Docker Compose contextual menu in the Visual Studio Code sidebar" />

    - **Using the terminal**: Using a terminal, navigate to this
      replication code directory and run this:

      ``` sh
      docker compose -f docker-compose.yml up
      ```

5.  Wait. It takes 20–30 minutes to build the {renv} library (but only
    the first time you run this; subsequent runs of `docker compose`
    should be instant), and it takes about 30–40 minutes to run the
    analysis (but only the first time; subsequent runs of
    `targets::tar_make()` should be instant).

    > [!IMPORTANT]
    >
    > ### Monitoring the pipeline progress
    >
    > Depending on how you run `docker compose`, you might not see the
    > progress of the {targets} pipeline. If you run it from the
    > terminal, you should; if you run it from Visual Studio Code, you
    > won’t. You can see the logs of the pipeline from the Docker
    > Desktop app in the container details, or by running `docker logs`
    > from the terminal.
    >
    > <img src="img/docker-logs.png" style="width:90.0%"
    > alt="Docker Desktop logs" />

6.  When the pipeline is all the way done, visit `http://localhost:8888`
    to see the analysis notebook and finished manuscript (at
    `http://localhost:8888/notebook/manuscript.html`).

    You can also see these outputs on your computer: the analysis
    notebook is at `silent-skywalk/_site` and the manuscript is at
    `silent-skywalk/manuscript/output/manuscript.html`.

7.  Additionally, you can explore the data and analysis in an RStudio
    session in your browser if you visit `http://localhost:8787`. Any
    edits you make here will also be reflected on your local computer.

## Method 2: {renv} locally

It’s also possible to not use Docker and instead run everything locally.

1.  Open `silent-skywalk/silent-skywalk.Rproj` to open a new RStudio
    project.

2.  Run `renv::restore()` to install all the packages.

3.  Run `cmdstanr::install_cmdstan()` to install
    [CmdStan](https://mc-stan.org/users/interfaces/cmdstan).

4.  Download and install the [Libre Franklin
    font](https://fonts.google.com/specimen/Libre+Franklin).

5.  Run `targets::tar_make()` to run the full analysis pipeline. This
    will take 30–40 minutes the first time.

6.  When the pipeline is all the way done, find the analysis notebook at
    `silent-skywalk/_site` and the manuscript at
    `silent-skywalk/manuscript/output/manuscript.html`.
