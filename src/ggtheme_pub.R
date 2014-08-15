theme_pub <- function(base_size = 12, base_family = "Helvetica") {
    windowsFonts(Helvetica=windowsFont("Helvetica"))
    theme_bw(base_size = base_size, base_family = base_family) %+replace%
    theme(
    panel.background =      element_blank(),   
    panel.grid.minor =      element_line(size = 0.25, colour = '#F5F5F5'), 
    panel.grid.major =      element_line(size = 0.25, colour = '#F0F0F0'), 
    
    plot.background =       element_blank(),  
    plot.title =            element_text(size = rel(1.2)),
    plot.margin  =          unit(rep(2, 4), "lines"),
    
    strip.background =      element_rect(fill = '#F0F0F0'),
    strip.text =            element_text(size = rel(0.8)),
    strip.text.x =          element_text(size = 20, face = "bold"),
    strip.text.y =          element_text(size = 20, face = "bold", angle = 270),  
    
    # axis.line =           element_blank(),
    axis.text    =          element_text(size = rel(0.8)),
    axis.text.y  =          element_text(size = 14, hjust = 1),
    axis.text.x  =          element_text(size = 18, vjust = 0),  
    axis.ticks   =          element_line(size = 0.50, colour = 'gray20', 
                                         color = "black"),     
    axis.title.x =          element_text(size = 20, face = "bold", 
                                         vjust = -0.5, hjust = 0.525),
    axis.title.y =          element_text(size = 20, angle = 90, 
                                         face = "bold", vjust = 0.25),
    axis.ticks.length =     unit(0.25, "cm"),  
    axis.ticks.margin =     unit(0.1, "cm"),        
    
    legend.background =     element_rect(colour = NA),
    legend.margin =         unit(0.2, "cm"),    
    legend.title =          element_text(colour = 'black', face = "bold", 
                                         hjust = -.1, vjust = .1, size = 12),
    legend.title.align =    NULL,    
    legend.text =           element_text(colour = 'black', vjust = 1.0, 
                                         size = 11),
    legend.text.align =     NULL,    
    legend.key =            element_rect(fill = NULL, colour = "grey80"),
    legend.key.height =     NULL,
    legend.key.width =      NULL,    
    legend.key.size =       unit(1.2, "lines"),    
    legend.position =       "right",
    legend.direction =      "vertical",
    legend.justification =  "center",    
    legend.box =            NULL,
                                   
    complete = TRUE
  )
}
