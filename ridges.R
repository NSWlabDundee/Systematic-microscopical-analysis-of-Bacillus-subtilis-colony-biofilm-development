# % Copyright (C) 2022 University of Dundee & Open Microscopy Environment.
# % All rights reserved.
# % 
# % This program is free software; you can redistribute it and/or modify
# % it under the terms of the GNU General Public License as published by
# % the Free Software Foundation; either version 2 of the License, or
# % (at your option) any later version.
# % 
# % This program is distributed in the hope that it will be useful,
# % but WITHOUT ANY WARRANTY; without even the implied warranty of
# % MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# % GNU General Public License for more details.
# % 
# % You should have received a copy of the GNU General Public License along
# % with this program; if not, write to the Free Software Foundation, Inc.,
# % 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

library(ggplot2)
library(dplyr)
library(ggridges)
library(stringr)
library(glue)
library(RColorBrewer)
library(wesanderson)
library(ggtext)

files <- list.files(path = ".",
                    pattern = ".csv")
steps <- data.frame(matrix(ncol = 3, nrow = 0 ))
colnames(steps) <- c("step","strain", "num")
order <- c("WT", "tapA", "sipW","tasA","tapAtasA","epsH","bslA")
value = 0
for (file in order) {
  
  value <- value + 1
  
  strain_name <- file
  print(strain_name)
  
  temp <- read.csv(glue("{file}steps9.csv"),
                   header = F,
                   stringsAsFactors = F) %>%
                   ##fileEncoding = "UTF-8-BOM") %>%
    rename(step = V1) %>%
    mutate(strain = strain_name, num = value)
  
  #rbind:
  steps <- rbind(steps,temp)
  
}
##try to plot:
colour_palette <- c("WT" = "#a9a9a9", "tapA" = "#d4d4d4", "sipW" = "#a9a9a9", "tasA" = "#d4d4d4", "tapAtasA" = "#a9a9a9", "epsH" = "#d4d4d4", "bslA" = "#a9a9a9")


#mutate arranged so that non-WT are italics
arranged <- steps %>%
  arrange(num) %>%
  mutate(name_fmt = ifelse(strain == "WT", strain, paste0("_*",strain,"*_")))



arranged$strain <- factor(arranged$strain, levels = rev(order))




ggplot(arranged) +
  geom_density_ridges(aes(x = step, y = name_fmt, fill = strain, height = ..density..), stat = "density", alpha = 0.8,rel_min_height = 0.005) +
  theme_bw() + # %+replace%
    #theme(axis.text.y = element_text(face = "italic")) +
  xlim(0,70) +
  xlab("Step Size (\u03bcm)") + 
  ylab("Strain") +
  theme(legend.position = "none", text=element_text(size=21),
        axis.text.y = element_markdown()) +
  scale_fill_manual(values = c(colour_palette))

ggsave("ridgeplot.png", dpi = 600, units = c("cm"), width = 15, height = 20)

  

