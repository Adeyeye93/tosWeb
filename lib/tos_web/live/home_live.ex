defmodule TosWeb.HomeLive do
    use TosWeb, :live_view
    alias Tos.Website

    def risk_level(score) do
      cond do
        score <= 10 -> "Minimal Risk"
        score <= 25 -> "Low Risk"
        score <= 40 -> "Moderate Risk"
        score <= 60 -> "Elevated Risk"
        score <= 80 -> "High Risk"
        true -> "Extreme Risk"
      end
    end


    def mount(_param, _sesson, sockets) do
        all_site = Website.get_all_site()
        site_count = Enum.count(all_site)
         group = Enum.group_by(all_site, fn site ->
            risk_level(site.risk_score)
          end)
           minimal = Map.get(group, "Minimal Risk", [])
          low = Map.get(group, "Low Risk", [])
          moderate = Map.get(group, "Moderate Risk", [])
          elevated = Map.get(group, "Elevated Risk", [])
          high = Map.get(group, "High Risk", [])
          extreme = Map.get(group, "Extreme Risk", [])

          minimal_count = Enum.count(minimal)
          low_count = Enum.count(low)
          moderate_count = Enum.count(moderate)
          elevated_count = Enum.count(elevated)
          high_count = Enum.count(high)
          extreme_count = Enum.count(extreme)


          sockets =
          sockets
          |> assign(all_site: all_site)
          |> assign(site_count: site_count)
          |> assign(minimal_count: minimal_count)
          |> assign(low_count: low_count)
          |> assign(moderate_count: moderate_count)
          |> assign(elevated_count: elevated_count)
          |> assign(high_count: high_count)
          |> assign(extreme_count: extreme_count)
          |> assign(
                    risk_labels: ["Minimal Risk", "Low Risk", "Moderate Risk", "Elevated Risk", "High Risk", "Extreme Risk"],
                    risk_counts: [minimal_count, low_count, moderate_count, elevated_count, high_count, extreme_count],
                    risk_colors: ["#28a745", "#cddc39", "#ffeb3b", "#ff9800", "#f44336", "#b71c1c"]
                  )

        {:ok, sockets}
    end


    def render(assigns) do
      ~H"""
        <div class="relative">
          <div class="grid grid-cols-12 gap-6">
            <div class="z-20 col-span-12 xl:col-span-9 2xl:col-span-9">
              <div class="mt-6 -mb-6">
                <div
                  class="box relative before:absolute before:inset-0 before:mx-3 before:-mb-3 before:border before:shadow-[0px_3px_5px_#0000000b] before:z-[-1] before:rounded-xl after:absolute after:inset-0 after:border after:shadow-[0px_3px_5px_#0000000b] after:rounded-xl after:z-[-1] after:backdrop-blur-md alert flex border items-center rounded-xl p-4 text-(--color) before:bg-(--color)/5 before:border-(--color)/15 after:bg-(--color)/10 after:border-(--color)/20 mb-6 border-transparent bg-transparent [--color:var(--color-warning)]"
                >
                  <span>
                    Introducing new dashboard! Download now at
                    <a
                      class="underline decoration-dotted underline-offset-2"
                      href="https://themeforest.net/item/midone-jquery-tailwindcss-html-admin-template/26366820"
                      target="blank"
                    >
                      themeforest.net
                    </a>
                    .
                  </span>
                  <a
                    class="ml-auto cursor-pointer"
                    data-tw-dismiss="alert"
                    type="button"
                    aria-label="Close"
                  >
                    <svg
                      xmlns="http://www.w3.org/2000/svg"
                      width="24"
                      height="24"
                      viewBox="0 0 24 24"
                      fill="none"
                      stroke="currentColor"
                      stroke-width="2"
                      stroke-linecap="round"
                      stroke-linejoin="round"
                      data-lucide="x"
                      class="lucide lucide-x size-4 stroke-[1.5] [--color:currentColor] stroke-(--color) fill-(--color)/25 w-4 h-4 ml-auto"
                    >
                      <path d="M18 6 6 18"></path>
                      <path d="m6 6 12 12"></path>
                    </svg>
                  </a>
                </div>
              </div>
              <div class="grid grid-cols-12 mb-3 mt-14 sm:gap-12">
                <div
                  class="relative col-span-12 py-6 text-center sm:col-span-6 sm:pl-5 sm:text-left md:col-span-4 md:pl-0 lg:pl-5"
                >
                  <div
                    data-tw-placement="bottom-end"
                    class="dropdown absolute right-0 top-0 mt-5 pt-0.5 2xl:mt-7 2xl:pt-0"
                  >
                    <a
                      data-tw-toggle="dropdown"
                      class="dropdown-toggle cursor-pointer relative z-[51] block"
                      href="#"
                    >
                      <svg
                        xmlns="http://www.w3.org/2000/svg"
                        width="24"
                        height="24"
                        viewBox="0 0 24 24"
                        fill="none"
                        stroke="currentColor"
                        stroke-width="2"
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        data-lucide="more-vertical"
                        class="lucide lucide-more-vertical size-4 stroke-[1.5] [--color:currentColor] stroke-(--color) fill-(--color)/25 opacity-70"
                      >
                        <circle cx="12" cy="12" r="1"></circle>
                        <circle cx="12" cy="5" r="1"></circle>
                        <circle cx="12" cy="19" r="1"></circle>
                      </svg>
                    </a>
                    <div
                      class="box before:absolute before:inset-0 before:mx-3 before:-mb-3 before:border before:border-foreground/10 before:bg-background/30 before:shadow-[0px_3px_5px_#0000000b] before:z-[-1] before:rounded-xl after:absolute after:inset-0 after:border after:border-foreground/10 after:bg-background after:shadow-[0px_3px_5px_#0000000b] after:rounded-xl after:z-[-1] after:backdrop-blur-md dropdown-menu invisible absolute z-50 p-1 opacity-0 before:backdrop-blur-xl [&amp;.show]:visible [&amp;.show]:opacity-100"
                    >
                      <div class="dropdown-content w-40">
                        <a
                          class="relative flex cursor-default select-none hover:bg-foreground/5 items-center rounded-lg px-2 py-1.5 outline-none transition-colors data-[disabled]:pointer-events-none data-[disabled]:opacity-50"
                        >
                          <svg
                            xmlns="http://www.w3.org/2000/svg"
                            width="24"
                            height="24"
                            viewBox="0 0 24 24"
                            fill="none"
                            stroke="currentColor"
                            stroke-width="2"
                            stroke-linecap="round"
                            stroke-linejoin="round"
                            data-lucide="file-text"
                            class="lucide lucide-file-text stroke-[1.5] [--color:currentColor] stroke-(--color) fill-(--color)/25 mr-2 size-4"
                          >
                            <path
                              d="M15 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7Z"
                            ></path>
                            <path d="M14 2v4a2 2 0 0 0 2 2h4"></path>
                            <path d="M10 9H8"></path>
                            <path d="M16 13H8"></path>
                            <path d="M16 17H8"></path>
                          </svg>
                          Monthly Report
                        </a>
                        <a
                          class="relative flex cursor-default select-none hover:bg-foreground/5 items-center rounded-lg px-2 py-1.5 outline-none transition-colors data-[disabled]:pointer-events-none data-[disabled]:opacity-50"
                        >
                          <svg
                            xmlns="http://www.w3.org/2000/svg"
                            width="24"
                            height="24"
                            viewBox="0 0 24 24"
                            fill="none"
                            stroke="currentColor"
                            stroke-width="2"
                            stroke-linecap="round"
                            stroke-linejoin="round"
                            data-lucide="file-text"
                            class="lucide lucide-file-text stroke-[1.5] [--color:currentColor] stroke-(--color) fill-(--color)/25 mr-2 size-4"
                          >
                            <path
                              d="M15 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7Z"
                            ></path>
                            <path d="M14 2v4a2 2 0 0 0 2 2h4"></path>
                            <path d="M10 9H8"></path>
                            <path d="M16 13H8"></path>
                            <path d="M16 17H8"></path>
                          </svg>
                          Annual Report
                        </a>
                      </div>
                    </div>
                  </div>
                  <div class="text-base">
                    Hi <span class="italic text-primary">Shane</span>, welcome back!
                  </div>
                  <div
                    class="flex items-center justify-center mt-14 sm:justify-start 2xl:mt-20"
                  >
                    <div class="text-base opacity-70">My Assets Value</div>
                    <div data-content="Last updated 1 hour ago" class="tooltip">
                      <svg
                        xmlns="http://www.w3.org/2000/svg"
                        width="24"
                        height="24"
                        viewBox="0 0 24 24"
                        fill="none"
                        stroke="currentColor"
                        stroke-width="2"
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        data-lucide="alert-circle"
                        class="lucide lucide-alert-circle stroke-[1.5] [--color:currentColor] stroke-(--color) fill-(--color)/10 ml-2 size-3.5"
                      >
                        <circle cx="12" cy="12" r="10"></circle>
                        <line x1="12" x2="12" y1="8" y2="12"></line>
                        <line x1="12" x2="12.01" y1="16" y2="16"></line>
                      </svg>
                    </div>
                  </div>
                  <div class="items-center my-3 2xl:flex">
                    <div
                      class="flex flex-wrap items-center justify-center gap-5 sm:justify-start"
                    >
                      <div
                        class="[--color:var(--color-primary)]/20 w-full text-2xl font-medium 2xl:w-auto"
                      >
                        <span class="relative -mr-0.5 inline-block size-3 text-lg">
                          <span class="absolute -mt-3.5">$</span>
                        </span>
                        977.713.302
                      </div>
                      <div
                        class="bg-(--color)/20 border-(--color)/60 text-(--color) flex cursor-pointer items-center rounded-full border px-2 py-px text-xs tooltip [--color:var(--color-primary)]"
                        data-content="9% Higher than last month"
                      >
                        47%
                        <svg
                          xmlns="http://www.w3.org/2000/svg"
                          width="24"
                          height="24"
                          viewBox="0 0 24 24"
                          fill="none"
                          stroke="currentColor"
                          stroke-width="2"
                          stroke-linecap="round"
                          stroke-linejoin="round"
                          data-lucide="chevron-up"
                          class="lucide lucide-chevron-up size-4 stroke-[1.5] [--color:currentColor] stroke-(--color) fill-(--color)/25 ml-0.5"
                        >
                          <path d="m18 15-6-6-6 6"></path>
                        </svg>
                      </div>
                      <a class="opacity-70" href="">
                        <svg
                          xmlns="http://www.w3.org/2000/svg"
                          width="24"
                          height="24"
                          viewBox="0 0 24 24"
                          fill="none"
                          stroke="currentColor"
                          stroke-width="2"
                          stroke-linecap="round"
                          stroke-linejoin="round"
                          data-lucide="refresh-ccw"
                          class="lucide lucide-refresh-ccw stroke-[1.5] [--color:currentColor] stroke-(--color) fill-(--color)/25 size-4"
                        >
                          <path
                            d="M21 12a9 9 0 0 0-9-9 9.75 9.75 0 0 0-6.74 2.74L3 8"
                          ></path>
                          <path d="M3 3v5h5"></path>
                          <path
                            d="M3 12a9 9 0 0 0 9 9 9.75 9.75 0 0 0 6.74-2.74L21 16"
                          ></path>
                          <path d="M16 16h5v5"></path>
                        </svg>
                      </a>
                    </div>
                  </div>
                  <div
                    class="bg-foreground/[.02] box mt-5 border px-3.5 pb-3.5 pt-3 text-xs leading-normal 2xl:mr-3"
                  >
                    <span class="opacity-80">
                      The value of your assets, calculated before any taxes are
                      deducted, is:
                    </span>
                    <a
                      class="decoration-foreground/50 text-primary mt-0.5 inline-block font-medium underline decoration-dotted underline-offset-2 opacity-70"
                      href=""
                    >
                      $721,206,851 </a>
                  </div>
                  <div
                    data-tw-placement="bottom-start"
                    class="dropdown mt-14 2xl:mr-3 2xl:mt-24"
                  >
                    <button
                      class="[--color:var(--color-foreground)] inline-flex border items-center gap-2 whitespace-nowrap rounded-lg text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 [&amp;_svg]:pointer-events-none [&amp;_svg]:size-4 [&amp;_svg]:shrink-0 text-(--color) hover:bg-(--color)/5 border-(--color)/20 h-10 py-2 dropdown-toggle cursor-pointer z-[51] relative justify-start w-full px-5 bg-transparent box"
                      data-tw-toggle="dropdown"
                    >
                      <svg
                        xmlns="http://www.w3.org/2000/svg"
                        width="24"
                        height="24"
                        viewBox="0 0 24 24"
                        fill="none"
                        stroke="currentColor"
                        stroke-width="2"
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        data-lucide="file-text"
                        class="lucide lucide-file-text stroke-[1.5] [--color:currentColor] stroke-(--color) fill-(--color)/25 mr-0.5 size-4"
                      >
                        <path
                          d="M15 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7Z"
                        ></path>
                        <path d="M14 2v4a2 2 0 0 0 2 2h4"></path>
                        <path d="M10 9H8"></path>
                        <path d="M16 13H8"></path>
                        <path d="M16 17H8"></path>
                      </svg>
                      Download Reports
                      <span
                        class="absolute top-0 bottom-0 right-0 flex items-center justify-center w-8 h-8 my-auto ml-auto mr-1"
                      >
                        <svg
                          xmlns="http://www.w3.org/2000/svg"
                          width="24"
                          height="24"
                          viewBox="0 0 24 24"
                          fill="none"
                          stroke="currentColor"
                          stroke-width="2"
                          stroke-linecap="round"
                          stroke-linejoin="round"
                          data-lucide="chevron-down"
                          class="lucide lucide-chevron-down stroke-[1.5] [--color:currentColor] stroke-(--color) fill-(--color)/25 size-4"
                        >
                          <path d="m6 9 6 6 6-6"></path>
                        </svg>
                      </span>
                    </button>
                    <div
                      class="box before:absolute before:inset-0 before:mx-3 before:-mb-3 before:border before:border-foreground/10 before:bg-background/30 before:shadow-[0px_3px_5px_#0000000b] before:z-[-1] before:rounded-xl after:absolute after:inset-0 after:border after:border-foreground/10 after:bg-background after:shadow-[0px_3px_5px_#0000000b] after:rounded-xl after:z-[-1] after:backdrop-blur-md dropdown-menu invisible absolute z-50 p-1 opacity-0 before:backdrop-blur-xl [&amp;.show]:visible [&amp;.show]:opacity-100"
                    >
                      <div class="dropdown-content w-44 2xl:w-64">
                        <a
                          class="relative flex cursor-default select-none hover:bg-foreground/5 items-center rounded-lg px-2 py-1.5 outline-none transition-colors data-[disabled]:pointer-events-none data-[disabled]:opacity-50"
                        >
                          <svg
                            xmlns="http://www.w3.org/2000/svg"
                            width="24"
                            height="24"
                            viewBox="0 0 24 24"
                            fill="none"
                            stroke="currentColor"
                            stroke-width="2"
                            stroke-linecap="round"
                            stroke-linejoin="round"
                            data-lucide="file-text"
                            class="lucide lucide-file-text stroke-[1.5] [--color:currentColor] stroke-(--color) fill-(--color)/25 mr-2 size-4"
                          >
                            <path
                              d="M15 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7Z"
                            ></path>
                            <path d="M14 2v4a2 2 0 0 0 2 2h4"></path>
                            <path d="M10 9H8"></path>
                            <path d="M16 13H8"></path>
                            <path d="M16 17H8"></path>
                          </svg>
                          Monthly Report
                        </a>
                        <a
                          class="relative flex cursor-default select-none hover:bg-foreground/5 items-center rounded-lg px-2 py-1.5 outline-none transition-colors data-[disabled]:pointer-events-none data-[disabled]:opacity-50"
                        >
                          <svg
                            xmlns="http://www.w3.org/2000/svg"
                            width="24"
                            height="24"
                            viewBox="0 0 24 24"
                            fill="none"
                            stroke="currentColor"
                            stroke-width="2"
                            stroke-linecap="round"
                            stroke-linejoin="round"
                            data-lucide="file-text"
                            class="lucide lucide-file-text stroke-[1.5] [--color:currentColor] stroke-(--color) fill-(--color)/25 mr-2 size-4"
                          >
                            <path
                              d="M15 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7Z"
                            ></path>
                            <path d="M14 2v4a2 2 0 0 0 2 2h4"></path>
                            <path d="M10 9H8"></path>
                            <path d="M16 13H8"></path>
                            <path d="M16 17H8"></path>
                          </svg>
                          Annual Report
                        </a>
                      </div>
                    </div>
                  </div>
                </div>
                <div
                  class="col-span-12 row-start-2 px-10 py-6 -mx-6 border-t border-dashed border-foreground/20 sm:px-28 md:col-span-4 md:row-start-auto md:border-l md:border-r md:border-t-0 md:px-6"
                >
                  <div class="flex flex-wrap items-center">
                    <div
                      class="flex items-center justify-center w-full mb-5 mr-auto sm:w-auto sm:justify-start 2xl:mb-0"
                    >
                      <div
                        class="bg-(--color)/20 border-(--color)/60 size-2 rounded-full border [--color:var(--color-primary)]"
                      ></div>
                      <div class="ml-3.5">
                        <div class="text-xl font-medium">$47,578.77</div>
                        <div class="mt-1 opacity-70">Yearly budget</div>
                      </div>
                    </div>
                    <select
                      class="bg-(image:--background-image-chevron) bg-[position:calc(100%-theme(spacing.3))_center] bg-[size:theme(spacing.5)] bg-no-repeat relative appearance-none flex h-10 rounded-md border ring-offset-background focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-foreground/5 focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50 box mx-auto -mt-2 w-auto bg-transparent px-3 py-1.5 sm:mx-0"
                    >
                      <option value="daily">Daily</option>
                      <option value="weekly">Weekly</option>
                      <option value="monthly">Monthly</option>
                      <option value="yearly">Yearly</option>
                      <option value="custom-date">Custom Date</option>
                    </select>
                  </div>
                  <div class="mt-10 opacity-70">
                    You have spent about 35% of your annual budget.
                  </div>
                  <div class="mt-6">
                    <div class="w-auto h-[270px]">
                      <canvas
                        id="report-bar-chart-1"
                        width="604"
                        height="540"
                        style="
                          display: block;
                          box-sizing: border-box;
                          height: 270px;
                          width: 302px;
                        "
                      ></canvas>
                    </div>
                  </div>
                </div>
                <div
                  class="col-span-12 py-6 pl-4 -ml-4 border-t border-l border-dashed sm:col-span-6 sm:border-t-0 md:col-span-4 md:ml-0 md:border-l-0 md:pl-0"
                >
                  <div class="tabs relative w-3/4 mx-auto 2xl:w-4/6">
                    <ul
                      role="tablist"
                      class="bg-foreground/5 relative z-0 mb-2 flex h-10 w-full select-none items-center justify-center rounded-xl p-1 [&amp;>*]:flex-1"
                    >
                      <li role="presentation" class="z-20 w-full">
                        <button
                          class="[&amp;.active]:bg-background inline-flex w-full cursor-pointer items-center justify-center whitespace-nowrap rounded-lg px-3 py-1.5 font-medium [&amp;.active]:shadow active"
                          type="button"
                          role="tab"
                          aria-selected="true"
                        >
                          Active
                        </button>
                      </li>
                      <li role="presentation" class="z-20 w-full">
                        <button
                          class="[&amp;.active]:bg-background inline-flex w-full cursor-pointer items-center justify-center whitespace-nowrap rounded-lg px-3 py-1.5 font-medium [&amp;.active]:shadow"
                          type="button"
                          role="tab"
                        >
                          Inactive
                        </button>
                      </li>
                    </ul>
                    <div class="tab-content">
                      <div
                        class="tab-pane hidden [&amp;.active]:block active"
                        role="tabpanel"
                        style="width: 228px"
                      >
                        <div class="mt-3.5">
                          <div class="relative">
                            <div class="w-auto h-[208px]">
                              <canvas
                                id="report-donut-chart"
                                data-risk-labels={Jason.encode!(@risk_labels)}
                                data-risk-counts={ Jason.encode!(@risk_counts)}
                                data-risk-colors={ Jason.encode!(@risk_colors)}
                                class="mt-3"
                                width="456"
                                height="392"
                                style="
                                  display: block;
                                  box-sizing: border-box;
                                  height: 196px;
                                  width: 228px;
                                "
                              ></canvas>
                            </div>
                            <div
                              class="absolute top-0 left-0 flex flex-col items-center justify-center w-full h-full"
                            >
                              <div class="text-2xl font-medium">{@site_count}</div>
                              <div class="mt-0.5 opacity-70">Active Sites</div>
                            </div>
                          </div>
                          <div class="mx-auto mt-5 w-52 sm:w-auto">
                            <div class="flex items-center">
                              <div
                                class="bg-[(--color)]/20 border-(--color)/60 mr-3 size-2 rounded-full border [--color:var(--color-primary)]"
                              ></div>
                              <span class="truncate">17 - 30 Years old</span>
                              <span class="ml-auto">62%</span>
                            </div>
                            <div class="flex items-center mt-4">
                              <div
                                class="bg-(--color)/20 border-(--color)/60 mr-3 size-2 rounded-full border [--color:var(--color-pending)]"
                              ></div>
                              <span class="truncate">31 - 50 Years old</span>
                              <span class="ml-auto">33%</span>
                            </div>
                            <div class="flex items-center mt-4">
                              <div
                                class="bg-(--color)/20 border-(--color)/60 mr-3 size-2 rounded-full border [--color:var(--color-warning)]"
                              ></div>
                              <span class="truncate">&gt;= 50 Years old</span>
                              <span class="ml-auto">10%</span>
                            </div>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <div
              class="z-10 col-span-12 pt-8 relative pb-14 before:content-[''] before:rounded-[30px] before:bg-background before:absolute before:inset-0 after:content-[''] after:rounded-[30px] after:bg-foreground/[.03] after:border after:absolute after:inset-0"
            >
              <div class="relative z-10 grid grid-cols-12 gap-6">
                <div
                  class="col-span-12 px-0 sm:col-span-4 lg:px-6 xl:col-span-3 xl:px-0 2xl:px-6"
                >
                  <div class="flex flex-wrap items-center gap-3 lg:flex-nowrap">
                    <div
                      class="mr-auto text-lg font-medium truncate sm:w-full lg:w-auto"
                    >
                      Summary Report
                    </div>
                    <div
                      class="text-(--color) flex cursor-pointer items-center rounded-full border px-2 py-px text-xs [--color:var(--color-foreground)] bg-(--color)/10 border-(--color)/40 ml-auto whitespace-nowrap"
                    >
                      180 Campaign
                    </div>
                  </div>
                  <div class="px-10 sm:px-0">
                    <div class="w-auto h-[110px]">
                      <canvas
                        id="simple-line-chart-3"
                        class="mt-8 -ml-1 -mb-7"
                        width="648"
                        height="212"
                        style="
                          display: block;
                          box-sizing: border-box;
                          height: 106px;
                          width: 324px;
                        "
                      ></canvas>
                    </div>
                  </div>
                </div>
                <div
                  class="col-span-12 px-0 sm:col-span-4 lg:px-6 xl:col-span-3 xl:px-0 2xl:px-6"
                >
                  <div class="flex flex-wrap items-center gap-3 lg:flex-nowrap">
                    <div
                      class="mr-auto text-lg font-medium truncate sm:w-full lg:w-auto"
                    >
                      Social Media
                    </div>
                    <a class="flex items-center text-primary" href="">
                      <div class="truncate 2xl:mr-auto">View Details</div>
                      <svg
                        xmlns="http://www.w3.org/2000/svg"
                        width="24"
                        height="24"
                        viewBox="0 0 24 24"
                        fill="none"
                        stroke="currentColor"
                        stroke-width="2"
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        data-lucide="arrow-right"
                        class="lucide lucide-arrow-right stroke-[1.5] [--color:currentColor] stroke-(--color) fill-(--color)/25 ml-3 size-4"
                      >
                        <path d="M5 12h14"></path>
                        <path d="m12 5 7 7-7 7"></path>
                      </svg>
                    </a>
                  </div>
                  <div class="flex items-center justify-center mt-9">
                    <div class="text-right">
                      <div class="text-xl font-medium">71,234,149</div>
                      <div class="mt-1 truncate opacity-70">Active Lenders</div>
                    </div>
                    <div
                      class="w-px h-16 mx-4 border border-r border-dashed xl:mx-6"
                    ></div>
                    <div>
                      <div class="text-xl font-medium">41,835,249</div>
                      <div class="mt-1 truncate opacity-70">Total Lenders</div>
                    </div>
                  </div>
                </div>
                <div
                  class="col-span-12 px-0 sm:col-span-4 lg:px-6 xl:col-span-3 xl:px-0 2xl:px-6"
                >
                  <div class="flex flex-wrap items-center gap-3 lg:flex-nowrap">
                    <div
                      class="mr-auto text-lg font-medium truncate sm:w-full lg:w-auto"
                    >
                      Posted Ads
                    </div>
                    <div
                      class="text-(--color) flex cursor-pointer items-center rounded-full border px-2 py-px text-xs [--color:var(--color-foreground)] bg-(--color)/10 border-(--color)/40 ml-auto whitespace-nowrap"
                    >
                      320 Followers
                    </div>
                  </div>
                  <div class="px-10 sm:px-0">
                    <div class="w-auto h-[110px]">
                      <canvas
                        id="simple-line-chart-4"
                        class="mt-8 -ml-1 -mb-7"
                        width="648"
                        height="212"
                        style="
                          display: block;
                          box-sizing: border-box;
                          height: 106px;
                          width: 324px;
                        "
                      ></canvas>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
          <div
            class="top-0 right-0 z-30 grid w-full h-full grid-cols-12 gap-6 pb-6 -mt-8 xl:absolute xl:z-auto xl:mt-0 xl:pb-0"
          >
            <div class="z-30 col-span-12 xl:col-span-3 xl:col-start-10 xl:pb-16">
              <div class="flex flex-col h-full">
                <div
                  class="box relative p-5 before:absolute before:inset-0 before:mx-3 before:-mb-3 before:border before:border-foreground/10 before:bg-background/30 before:shadow-[0px_3px_5px_#0000000b] before:z-[-1] before:rounded-xl after:absolute after:inset-0 after:border after:border-foreground/10 after:bg-background after:shadow-[0px_3px_5px_#0000000b] after:rounded-xl after:z-[-1] after:backdrop-blur-md mt-6"
                >
                  <div class="flex flex-wrap items-center gap-3">
                    <div class="mr-auto">
                      <div class="flex items-center text-xs opacity-70">
                        TOTAL SITE
                        <div data-content="Including sites you restricted TOS from" class="tooltip">
                          <svg
                            xmlns="http://www.w3.org/2000/svg"
                            width="24"
                            height="24"
                            viewBox="0 0 24 24"
                            fill="none"
                            stroke="currentColor"
                            stroke-width="2"
                            stroke-linecap="round"
                            stroke-linejoin="round"
                            data-lucide="alert-circle"
                            class="lucide lucide-alert-circle stroke-[1.5] [--color:currentColor] stroke-(--color) fill-(--color)/10 -mt-0.5 ml-2 size-3.5"
                          >
                            <circle cx="12" cy="12" r="10"></circle>
                            <line x1="12" x2="12" y1="8" y2="12"></line>
                            <line x1="12" x2="12.01" y1="16" y2="16"></line>
                          </svg>
                        </div>
                      </div>
                      <div class="relative mt-3.5 text-xl font-medium leading-5">
                        { @site_count }
                      </div>
                    </div>
                    <button
                      class="[--color:var(--color-foreground)] cursor-pointer inline-flex border items-center justify-center gap-2 whitespace-nowrap text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 [&amp;_svg]:pointer-events-none [&amp;_svg]:size-4 [&amp;_svg]:shrink-0 text-(--color) hover:bg-(--color)/5 bg-background border-(--color)/20 px-4 py-2 rounded-full size-10"
                    >
                      <svg
                        xmlns="http://www.w3.org/2000/svg"
                        width="24"
                        height="24"
                        viewBox="0 0 24 24"
                        fill="none"
                        stroke="currentColor"
                        stroke-width="2"
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        data-lucide="plus"
                        class="lucide lucide-plus stroke-[1.5] [--color:currentColor] stroke-(--color) fill-(--color)/25 size-6"
                      >
                        <path d="M5 12h14"></path>
                        <path d="M12 5v14"></path>
                      </svg>
                    </button>
                  </div>
                </div>
                <div
                  class="box relative p-5 before:absolute before:inset-0 before:mx-3 before:-mb-3 before:border before:border-foreground/10 before:bg-background/30 before:shadow-[0px_3px_5px_#0000000b] before:z-[-1] before:rounded-xl after:absolute after:inset-0 after:border after:border-foreground/10 after:bg-background after:shadow-[0px_3px_5px_#0000000b] after:rounded-xl after:z-[-1] after:backdrop-blur-md mt-8 xl:min-h-0"
                >
                  <div class="flex items-center">
                    <div class="mr-5 text-lg font-medium truncate">Your Privacy Risk Scale</div>
                    <a class="flex items-center ml-auto text-primary" href="">
                      <svg
                        xmlns="http://www.w3.org/2000/svg"
                        width="24"
                        height="24"
                        viewBox="0 0 24 24"
                        fill="none"
                        stroke="currentColor"
                        stroke-width="2"
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        data-lucide="refresh-ccw"
                        class="lucide lucide-refresh-ccw stroke-[1.5] [--color:currentColor] stroke-(--color) fill-(--color)/25 mr-3 size-4"
                      >
                        <path
                          d="M21 12a9 9 0 0 0-9-9 9.75 9.75 0 0 0-6.74 2.74L3 8"
                        ></path>
                        <path d="M3 3v5h5"></path>
                        <path
                          d="M3 12a9 9 0 0 0 9 9 9.75 9.75 0 0 0 6.74-2.74L21 16"
                        ></path>
                        <path d="M16 16h5v5"></path>
                      </svg>
                      Refresh
                    </a>
                  </div>
                  <div class="tabs relative w-full mt-5">
                    <ul
                      role="tablist"
                      class="bg-foreground/5 relative z-0 mb-2 flex h-10 w-full select-none items-center justify-center rounded-xl p-1 [&amp;>*]:flex-1"
                    >
                      <li role="presentation" class="z-20 w-full">
                        <button
                          class="[&amp;.active]:bg-background inline-flex w-full cursor-pointer items-center justify-center whitespace-nowrap rounded-lg px-3 py-1.5 font-medium [&amp;.active]:shadow active"
                          type="button"
                          role="tab"
                          aria-selected="true"
                          data-tw-target="#tab-id-0-8103"
                        >
                          Weekly
                        </button>
                      </li>
                      <li role="presentation" class="z-20 w-full">
                        <button
                          class="[&amp;.active]:bg-background inline-flex w-full cursor-pointer items-center justify-center whitespace-nowrap rounded-lg px-3 py-1.5 font-medium [&amp;.active]:shadow"
                          type="button"
                          role="tab"
                          aria-selected="false"
                          data-tw-target="#tab-id-1-1853"
                        >
                          Monthly
                        </button>
                      </li>
                    </ul>
                    <div class="tab-content">
                      <div
                        class="tab-pane hidden [&amp;.active]:block active"
                        role="tabpanel"
                        id="tab-id-0-8103"
                        style="width: 280px"
                      >
                        <div class="grid grid-cols-12 mt-6 gap-y-7">
                          <div
                            class="col-span-12 sm:col-span-6 md:col-span-4 xl:col-span-12"
                          >
                            <div class="text-xs opacity-70" style="text-transform: uppercase;">Minimal Risk
                            </div>

                            <div class="mt-1.5 flex items-center">
                              <div class="text-base">{@minimal_count} sites</div>
                              <div
                                class="text-(--color) flex cursor-pointer items-center rounded-full border px-2 py-px text-xs tooltip border-transparent bg-transparent [--color:var(--color-success)]"
                                data-content="Almost no concerning practices detected. Generally safe to proceed."
                              >
                                 0 – 10%
                                <svg
                                  xmlns="http://www.w3.org/2000/svg"
                                  width="24"
                                  height="24"
                                  viewBox="0 0 24 24"
                                  fill="#28a745"
                                  stroke="#28a745"
                                  stroke-width="2"
                                  stroke-linecap="round"
                                  stroke-linejoin="round"
                                  data-lucide="chevron-up"
                                  class="lucide lucide-chevron-up size-6 stroke-[3] [--color:#28a745] stroke-(#28a745) fill-#28a745 ml-0.5"
                                >
                                  <path d="m18 15-6-6-6 6"></path>
                                </svg>
                              </div>
                            </div>
                          </div>
                          <div
                            class="col-span-12 sm:col-span-6 md:col-span-4 xl:col-span-12"
                          >
                            <div class="text-xs opacity-70" style="text-transform: uppercase;"> Low Risk</div>
                            <div class="mt-1.5 flex items-center">
                              <div class="text-base">{@low_count} sites</div>
                              <div
                                class="text-#cddc39 flex cursor-pointer items-center rounded-full border px-2 py-px text-xs tooltip border-transparent bg-transparent [--color:#cddc39]"
                                data-content="Minor concerns found. Review if necessary, but acceptable for most users."
                              >
                                11 – 25%
                                <svg
                                  xmlns="http://www.w3.org/2000/svg"
                                  width="24"
                                  height="24"
                                  viewBox="0 0 24 24"
                                  fill="#cddc39"
                                  stroke="#cddc39"
                                  stroke-width="2"
                                  stroke-linecap="round"
                                  stroke-linejoin="round"
                                  data-lucide="chevron-up"
                                  class="lucide lucide-chevron-down size-6 stroke-[3] [--color:#cddc39] stroke-#cddc39 fill-#cddc39/25 ml-0.5"
                                >
                                  <path d="m6 9 6 6 6-6"></path>
                                </svg>
                              </div>
                            </div>
                          </div>
                          <div
                            class="col-span-12 sm:col-span-6 md:col-span-4 xl:col-span-12"
                          >
                            <div class="text-xs opacity-70" style="text-transform: uppercase;">Moderate Risk</div>
                            <div class="mt-1.5 flex items-center">
                              <div class="text-base">{@moderate_count} sites</div>
                              <div
                                class="text-(--color) flex cursor-pointer items-center rounded-full border px-2 py-px text-xs tooltip border-transparent bg-transparent [--color:var(--color-success)]"
                                data-content="Noticeable concerns detected. Review policy carefully before proceeding."
                              >
                                26 – 40%
                                <svg
                                  xmlns="http://www.w3.org/2000/svg"
                                  width="24"
                                  height="24"
                                  viewBox="0 0 24 24"
                                  fill="#ffeb3b"
                                  stroke="#ffeb3b"
                                  stroke-width="2"
                                  stroke-linecap="round"
                                  stroke-linejoin="round"
                                  data-lucide="chevron-up"
                                  class="lucide lucide-chevron-up size-6 stroke-[3] [--color:#ffeb3b] stroke-[#ffeb3b] fill-[#ffeb3b]/25 ml-0.5"
                                >
                                  <path d="m18 15-6-6-6 6"></path>
                                </svg>
                              </div>
                            </div>
                          </div>
                          <div
                            class="col-span-12 sm:col-span-6 md:col-span-4 xl:col-span-12"
                          >
                            <div class="text-xs opacity-70" style="text-transform: uppercase;">Elevated Risk</div>
                            <div class="mt-1.5 flex items-center">
                              <div class="text-base">{@elevated_count} sites</div>
                              <div
                                class="text-(--color) flex cursor-pointer items-center rounded-full border px-2 py-px text-xs tooltip border-transparent bg-transparent [--color:var(--color-danger)]"
                                data-content="Multiple significant concerns found. Caution advised."
                              >
                                41 – 60%
                                <svg
                                  xmlns="http://www.w3.org/2000/svg"
                                  width="24"
                                  height="24"
                                  viewBox="0 0 24 24"
                                  fill="#ff9800"
                                  stroke="#ff9800"
                                  stroke-width="2"
                                  stroke-linecap="round"
                                  stroke-linejoin="round"
                                  data-lucide="chevron-down"
                                  class="lucide lucide-chevron-up size-6 stroke-[3] [--color:#ff9800] stroke-[#ff9800] fill-[#ff9800]/25 ml-0.5"
                                >
                                  <path d="m18 15-6-6-6 6"></path>
                                </svg>
                              </div>
                            </div>
                          </div>
                          <div
                            class="col-span-12 sm:col-span-6 md:col-span-4 xl:col-span-12"
                          >
                            <div class="text-xs opacity-70" style="text-transform: uppercase;">
                              High Risk
                            </div>
                            <div class="mt-1.5 flex items-center">
                              <div class="text-base">{@high_count} sites</div>
                              <div
                                class="text-(--color) flex cursor-pointer items-center rounded-full border px-2 py-px text-xs tooltip border-transparent bg-transparent [--color:var(--color-danger)]"
                                data-content="High number of risky or exploitative clauses. Strongly reconsider usage."
                              >
                                61 – 80%
                                <svg
                                  xmlns="http://www.w3.org/2000/svg"
                                  width="24"
                                  height="24"
                                  viewBox="0 0 24 24"
                                  fill="#f44336"
                                  stroke="#f44336"
                                  stroke-width="2"
                                  stroke-linecap="round"
                                  stroke-linejoin="round"
                                  data-lucide="chevron-down"
                                  class="lucide lucide-chevron-up size-6 stroke-[3] [--color:#f44336] stroke-[#f44336] fill-[#f44336]/25 ml-0.5"
                                >
                                  <path d="m18 15-6-6-6 6"></path>
                                </svg>
                              </div>
                            </div>
                          </div>
                          <div
                            class="col-span-12 sm:col-span-6 md:col-span-4 xl:col-span-12"
                          >
                            <div class="text-xs opacity-70" style="text-transform: uppercase;">Extreme Risk</div>
                            <div class="mt-1.5 flex items-center">
                              <div class="text-base">{@extreme_count} sites</div>
                              <div
                                class="text-(--color) flex cursor-pointer items-center rounded-full border px-2 py-px text-xs tooltip border-transparent bg-transparent [--color:var(--color-danger)]"
                                data-content="Extremely dangerous or invasive practices detected. Avoid or take immediate action to protect your data."
                              >
                                81 - 100%
                                <svg
                                  xmlns="http://www.w3.org/2000/svg"
                                  width="24"
                                  height="24"
                                  viewBox="0 0 24 24"
                                  fill="#b71c1c"
                                  stroke="#b71c1c"
                                  stroke-width="2"
                                  stroke-linecap="round"
                                  stroke-linejoin="round"
                                  data-lucide="chevron-down"
                                  class="lucide lucide-chevron-down size-6 stroke-[3] [--color:#b71c1c] stroke-[#b71c1c] fill-[#b71c1c]/25 ml-0.5"
                                >
                                  <path d="m6 9 6 6 6-6"></path>
                                </svg>
                              </div>
                            </div>
                          </div>
                          <button
                            class="[--color:var(--color-foreground)] cursor-pointer inline-flex border items-center gap-2 whitespace-nowrap rounded-lg text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 [&amp;_svg]:pointer-events-none [&amp;_svg]:size-4 [&amp;_svg]:shrink-0 text-(--color) hover:bg-(--color)/5 bg-background border-(--color)/20 h-10 px-4 py-2 relative justify-start col-span-12 border-dashed"
                          >
                            <span class="mr-5 truncate"> My Portfolio Details </span>
                            <span
                              class="absolute bottom-0 right-0 top-0 my-auto ml-auto mr-0.5 flex h-8 w-8 items-center justify-center"
                            >
                              <svg
                                xmlns="http://www.w3.org/2000/svg"
                                width="24"
                                height="24"
                                viewBox="0 0 24 24"
                                fill="none"
                                stroke="currentColor"
                                stroke-width="2"
                                stroke-linecap="round"
                                stroke-linejoin="round"
                                data-lucide="arrow-right"
                                class="lucide lucide-arrow-right stroke-[1.5] [--color:currentColor] stroke-(--color) fill-(--color)/25 size-4"
                              >
                                <path d="M5 12h14"></path>
                                <path d="m12 5 7 7-7 7"></path>
                              </svg>
                            </span>
                          </button>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

      """
    end

end
